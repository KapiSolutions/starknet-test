<script lang="ts">
	import { disconnect } from "starknetkit"
	import { walletStore } from "../stores/walletStore"
	import { toasts } from "../stores/toastStore"
	import CopyIcon from "../icons/CopyIcon.svelte"
	import ExitIcon from "../icons/ExitIcon.svelte"
	import { onDestroy, onMount } from "svelte"

	type Props = {
		showModal: boolean
		onClose: () => void
	}

	let { showModal = true, onClose }: Props = $props()
	let element = $state<HTMLDivElement>()

	const handleClickOutside = (event: MouseEvent) => {
		if (element && !element.contains(event.target as Node)) {
			onClose()
		}
	}
	onMount(() => {
		if (typeof window !== "undefined") {
			document.addEventListener("click", handleClickOutside)
		}
	})
	onDestroy(() => {
		if (typeof window !== "undefined") {
			document.removeEventListener("click", handleClickOutside)
		}
	})

	const disconnectWallet = async () => {
		await disconnect()
		walletStore.clear()
		onClose()
		toasts.add({ message: "Wallet disconnected!" })
	}
	const copyAddress = async () => {
		if (!$walletStore) return
		try {
			await navigator.clipboard.writeText($walletStore.selectedAddress)
			toasts.add({ message: "Address copied!" })
		} catch (error) {
			console.error("Failed to copy address:", error)
			toasts.add({
				message: "Failed to copy address. Please check clipboard permissions.",
				type: "error"
			})
		}
	}
</script>

{#if $walletStore}
	<div
		class="modal"
		class:showModal
		role="dialog"
		aria-modal="true"
		aria-labelledby="wallet-modal-title"
	>
		<div class="card" bind:this={element}>
			<button class="close" onclick={onClose} aria-label="Close modal">⛌</button>

			<div class="logo">
				{#if $walletStore.icon}
					<img src={$walletStore.icon} alt="Wallet icon" width="48" />
				{/if}
			</div>

			<h3>
				<code
					>{$walletStore.selectedAddress.slice(0, 5)}...{$walletStore.selectedAddress.slice(
						60,
						66
					)}</code
				>
			</h3>
			<div class="actions">
				<button class="action-btn" onclick={copyAddress}>
					<CopyIcon />
					<small>Copy Address</small></button
				>
				<button class="action-btn" onclick={disconnectWallet}>
					<ExitIcon />
					<small>Disconnect</small></button
				>
			</div>
		</div>
	</div>
{/if}

<style>
	.modal {
		display: none;
		position: fixed;
		top: 0;
		left: 0;
		overflow: hidden;
		background-color: rgba(0, 0, 0, 0.316);
		backdrop-filter: blur(4px) saturate(180%);
		width: 100%;
		height: 100%;
		place-items: center;
		color: var(--text-dark);
		text-align: center;
		z-index: 100;
	}
	.showModal {
		display: flex;
		align-items: center;
		justify-content: center;
	}
	.card {
		position: relative;
		background-color: var(--bg-light);
		padding: 1rem;
		border-radius: var(--radius-lg);
		box-shadow: 0 16px 16px rgba(0, 0, 0, 0.4);
		width: 320px;
		display: flex;
		flex-direction: column;
		gap: 1rem;
	}
	.close {
		position: absolute;
		top: 0;
		right: 4px;
		padding: 0.5rem;
		background: none;
		border-radius: 50%;
		border: none;
		cursor: pointer;
	}
	.close:hover {
		transform: scale(1.1);
	}
	.logo {
		width: 100%;
		display: flex;
		align-items: center;
		justify-content: center;
		gap: 0.5rem;
		padding: 16px 0 0 0;
	}
	.actions {
		display: flex;
		gap: 1rem;
		justify-content: center;
	}
	.action-btn {
		background-color: white;
		color: var(--text-dark);
		padding: 0.5rem 1.5rem;
		border: none;
		border-radius: 8px;
		cursor: pointer;
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
	}
	.action-btn:hover {
		background-color: rgb(251, 251, 251);
		box-shadow: 0 6px 6px rgba(0, 0, 0, 0.1);
	}
</style>
