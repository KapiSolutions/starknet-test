<script lang="ts">
	import { Provider, Contract, RpcProvider, Account } from 'starknet'
	import { walletStore } from '../stores/walletStore'
	import counterAbi from '../abis/counterAbi.json'
	import {
		DEVNET_ACCOUNT,
		DEVNET_CONTRACT_ADDRESS,
		SEPOLIA_CONTRACT_ADDRESS
	} from '../../config/config'
	import Button from './Button.svelte'
	import { toasts } from '../stores/toastStore'
	import Card from './Card.svelte'
	import { scale } from 'svelte/transition'

	let contractAddress = $state<string>('')
	let balance = $state<string | null>(null)
	let provider = $state<Provider>()
	let isSepolia = $state<boolean>(false)
	let status = $state<string>('')
	let loading = $state<'increase' | 'decrease' | 'reset' | ''>('')
	let tx = $state<string>('')

	$effect(() => {
		const nodeUrl: string | undefined = $walletStore?.provider?.provider?.nodeUrl

		if (nodeUrl?.includes('argent-api')) window.location.reload()
		if (nodeUrl?.includes('localhost')) {
			contractAddress = DEVNET_CONTRACT_ADDRESS
			isSepolia = false
		} else {
			contractAddress = SEPOLIA_CONTRACT_ADDRESS
			isSepolia = true
		}

		provider = new RpcProvider({ nodeUrl: nodeUrl })
		balance = null
	})

	$effect(() => {
		if (!balance) fetchBalance()
	})

	async function fetchBalance() {
		// if (!provider) return console.error('Provider not initialized')
		// const { abi: testAbi } = await provider.getClassAt(contractAddress)
		// if (testAbi === undefined) {
		// 	throw new Error('no abi.')
		// }
		// console.log('testAbi', JSON.stringify(testAbi, undefined, 2))
		try {
			const contract = new Contract(counterAbi, contractAddress, provider)
			balance = ''
			balance = (await contract.get_counter()).toString()
		} catch (error) {
			console.error(error)
		}
	}

	async function invokeFunction(fun: 'increase' | 'decrease' | 'reset') {
		if (!provider) return console.error('Provider not initialized')
		try {
			loading = fun
			tx = ''
			const account = getAccount()
			const myTestContract = new Contract(counterAbi, contractAddress, account)

			status = 'Waiting for confirmation...'
			let res
			if (fun === 'increase') {
				res = await myTestContract.increase_counter()
			} else if (fun === 'decrease') {
				res = await myTestContract.decrease_counter()
			} else if (fun === 'reset') {
				res = await myTestContract.reset_counter()
			}

			tx = res.transaction_hash
			status = 'Transaction sent. Waiting for execution...'
			await provider.waitForTransaction(res.transaction_hash)
			await fetchBalance()
			toasts.add({
				message: '🎉  Transaction successful!',
				type: 'success'
			})
		} catch (error) {
			const err = error instanceof Error ? error.message : 'Details in console.'
			console.error(error)
			toasts.add({
				message: 'Transaction error - ' + err,
				type: 'error'
			})
		} finally {
			loading = ''
			status = ''
		}
	}

	function getAccount() {
		if (!provider) return
		if (isSepolia) {
			return $walletStore?.account
		} else {
			return new Account(
				provider,
				DEVNET_ACCOUNT.address,
				DEVNET_ACCOUNT.privateKey,
				DEVNET_ACCOUNT.cairo,
				'0x3'
			)
		}
	}
</script>

<Card>
	<div class="container">
		<div class="info">
			<div>
				<p class="title">Contract address</p>
				<a
					class="data"
					href="https://sepolia.starkscan.co/contract/{contractAddress}"
					rel="noopener noreferrer"
					target="_blank"
				>
					{contractAddress?.slice(0, 5)}...{contractAddress?.slice(-4)}
				</a>
			</div>
			<div>
				<p class="title">Balance</p>
				{#key balance}
					<p class="data" in:scale={{ duration: 1000, start: 1.5 }}>{balance}</p>
				{/key}
			</div>
		</div>
		<div class="actions">
			<Button onClick={fetchBalance} white disabled={!!loading}>Get Balance</Button>
			<Button
				onClick={() => {
					invokeFunction('increase')
				}}
				loading={loading === 'increase'}
				disabled={!!loading}>Increase Balance</Button
			>
			<Button
				onClick={() => {
					invokeFunction('decrease')
				}}
				loading={loading === 'decrease'}
				disabled={!!loading || balance === '0'}>Decrease Balance</Button
			>
			<Button
				onClick={() => {
					invokeFunction('reset')
				}}
				loading={loading === 'reset'}
				disabled={!!loading}>Reset Balance</Button
			>
		</div>

		{#if status}
			<code>{status}</code>
		{/if}

		{#if isSepolia && tx && !loading}
			<a href="https://sepolia.starkscan.co/tx/{tx}" rel="noopener noreferrer" target="_blank"
				><code>Check transaction on STARKSCAN ✨</code></a
			>
		{/if}
	</div>
</Card>

<style>
	.container {
		display: flex;
		flex-direction: column;
		gap: 2rem;
		width: 310px;
		align-items: center;
		justify-content: center;
		padding-bottom: 0.5rem;
	}
	.info {
		display: flex;
		align-items: top;
		justify-content: space-evenly;
		gap: 2rem;
		width: 100%;

		.title {
			font-size: small;
			margin-bottom: 0.2rem;
			opacity: 0.8;
		}
		.data {
			font-size: large;
			font-weight: bold;

			color: var(--text-light);
			opacity: 1;
		}
	}
	.actions {
		display: flex;
		flex-direction: column;
		gap: 1rem;
		max-width: 200px;
		text-align: center;
	}
	code {
		text-align: center;
	}
	a {
		text-decoration: none;
		color: whitesmoke;
		opacity: 0.8;
		&:hover {
			opacity: 1;
		}
	}
</style>
