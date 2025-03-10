<script lang="ts">
	import type { StarknetKitWallet } from "../types/starknetkit"
	import WalletModal from "./WalletModal.svelte"

	type Props = {
		wallet: StarknetKitWallet
	}

	let { wallet }: Props = $props()
	let showModal = $state(false)
</script>

<button
	class="container"
	onclick={(e) => {
		e.stopPropagation()
		showModal = true
	}}
>
	<img src={wallet.icon} alt="Wallet icon" width="20" />
	<small>{wallet.selectedAddress.slice(0, 5)}...{wallet.selectedAddress.slice(60, 66)}</small>
</button>

<WalletModal {showModal} onClose={() => (showModal = false)} />

<style>
	.container {
		background: var(--bg-dimmed);
		border: none;
		color: inherit;
		border-radius: var(--radius-sm);
		box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
		padding: 1rem;
		display: flex;
		place-items: center;
		gap: 1rem;
		cursor: pointer;
	}
</style>
