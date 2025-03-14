<script lang="ts">
	import AnimatedBorder from './lib/components/AnimatedBorder.svelte'
	import Contract from './lib/components/Contract.svelte'
	import Layout from './lib/components/Layout.svelte'
	import { walletStore } from './lib/stores/walletStore'
</script>

<Layout>
	{#if $walletStore}
		{#if $walletStore.chainId === 'SN_MAIN'}
			<div class="message">
				<p>This is test dapp, Mainnet is unsuported.</p>
				<p class="bigger">Change network to Sepolia or Local Devnet</p>
			</div>
		{:else}
			<AnimatedBorder color="#ffe4c434"><Contract /></AnimatedBorder>
		{/if}
	{:else}
		<img src="/images/logo.png" width="400px" alt="logo" />
	{/if}
</Layout>

<style>
	.bigger {
		font-size: large;
		font-weight: bold;
	}
	.message {
		display: flex;
		flex-direction: column;
		gap: 2rem;
		margin-top: 2rem;
		text-align: center;
	}
</style>
