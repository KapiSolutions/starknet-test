<script lang="ts">
	import { onDestroy, onMount } from 'svelte'
	import { connect, getSelectedConnectorWallet } from 'starknetkit'
	import { walletStore } from '../stores/walletStore'
	import { toasts } from '../stores/toastStore'
	import WalletMenu from './WalletMenu.svelte'
	import type { StarknetKitWallet } from '../types/starknetkit'
	import AnimatedButton from './AnimatedButton.svelte'

	let loading = $state(false)
	let wallet = $state<StarknetKitWallet | null>(null)

	const isBrowserCompatible = () => {
		return !!(typeof window !== 'undefined' && (window.ethereum || window.starknet))
	}

	onMount(() => {
		if (isBrowserCompatible()) connectToStarknet()
	})

	$effect(() => {
		wallet?.on('accountsChanged', (accounts: string[] | undefined) => {
			console.log('accountsChanged: ', accounts)
			wallet = getActWallet() as StarknetKitWallet
			walletStore.set(wallet)
		})
		wallet?.on('networkChanged', (chainId: string[] | string) => {
			console.log('networkChanged: ', chainId)
			wallet = getActWallet() as StarknetKitWallet
			walletStore.set(wallet)
		})
	})

	const getActWallet = () => {
		const res = getSelectedConnectorWallet()
		// getSelectedConnectorWallet() method returns different object structures, mapping needed:
		if (res.provider.channel) {
			res.provider = { provider: res.provider.channel }
			return res
		}
		if (!res.provider.provider) {
			res.provider = { provider: res.provider }
			return res
		}
		return res
	}

	onDestroy(() => {
		if (wallet) {
			wallet.off('networkChanged', () => {})
			wallet.off('accountsChanged', () => {})
			wallet = null
		}
	})

	const connectToStarknet = async () => {
		try {
			const { wallet: walletX } = await connect({ modalMode: 'neverAsk' })
			wallet = walletX as unknown as StarknetKitWallet
			console.log('wallet', walletX)

			if (wallet && wallet.isConnected) walletStore.set(wallet)
		} catch (error) {
			console.error('Error connecting wallet: ', error)
			toasts.add({
				message: 'Error connecting wallet',
				type: 'error'
			})
		}
	}
	const connectWallet = async () => {
		loading = true
		try {
			const { wallet: walletX } = await connect({
				dappName: 'Starknet_test',
				modalMode: 'alwaysAsk',
				modalTheme: 'light',
				webWalletUrl: 'https://web.argent.xyz'
			})
			wallet = walletX as unknown as StarknetKitWallet
			console.log('wallet', walletX)

			if (wallet && wallet.isConnected) {
				walletStore.set(wallet)
				toasts.add({ message: '🎉  Wallet connected!' })
			}
		} catch (error) {
			console.error('Error connecting wallet: ', error)
			toasts.add({
				message: 'Error connecting wallet',
				type: 'error'
			})
		} finally {
			loading = false
		}
	}
</script>

<header>
	<p class="title">Starknet<span>_TEST</span></p>
	{#if $walletStore}
		<WalletMenu wallet={$walletStore} />
	{:else}
		<AnimatedButton onClick={connectWallet} {loading}>Connect Wallet</AnimatedButton>
	{/if}
</header>

<style>
	header {
		display: flex;
		align-items: center;
		justify-content: space-between;
		width: 100%;
		padding: 1rem;
	}
	.title {
		font-size: 1.5rem;
		font-weight: 600;
		span {
			font-size: small;
			opacity: 0.8;
		}
	}
</style>
