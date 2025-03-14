<script lang="ts">
	import type { Snippet } from 'svelte'

	type Props = {
		children: Snippet
		onClick?: (e: Event) => void
		type?: 'button' | 'submit' | 'reset'
		disabled?: boolean
		loading?: boolean
		white?: boolean
	}
	let {
		children,
		onClick,
		type = 'button',
		disabled = false,
		loading = false,
		white
	}: Props = $props()
</script>

<button
	onclick={onClick}
	{type}
	disabled={disabled || loading}
	class:disabled={disabled || loading}
	class:white
	>{#if loading}
		<span class="spinner"></span>
	{/if}{@render children()}</button
>

<style>
	button {
		background-color: var(--primary);
		border: none;
		border-radius: var(--radius);
		color: white;
		padding: 10px 16px;
		text-align: center;
		text-decoration: none;
		display: flex;
		display: inline-flex;
		align-items: center;
		justify-content: center;
		font-size: 16px;
		cursor: pointer;
	}
	.disabled {
		opacity: 0.8;
		pointer-events: none;
	}
	.spinner {
		display: inline-block;
		width: 16px;
		height: 16px;
		border: 3px solid rgba(255, 255, 255, 0.3);
		border-radius: 50%;
		border-top-color: #fff;
		margin-right: 0.5rem;
		animation: spin 1s ease-in-out infinite;
		-webkit-animation: spin 1s ease-in-out infinite;
	}
	.white {
		background-color: var(--text-light);
		color: var(--text-dark);
	}

	@keyframes spin {
		to {
			transform: rotate(360deg);
		}
	}
	@-webkit-keyframes spin {
		to {
			-webkit-transform: rotate(360deg);
		}
	}
</style>
