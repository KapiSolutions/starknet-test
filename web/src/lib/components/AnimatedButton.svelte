<script lang="ts">
	import type { Snippet } from 'svelte'

	type Props = {
		children: Snippet
		onClick?: (e: Event) => void
		type?: 'button' | 'submit' | 'reset'
		disabled?: boolean
		loading?: boolean
	}
	let { children, onClick, type = 'button', disabled = false, loading = false }: Props = $props()
</script>

<button
	onclick={onClick}
	{type}
	disabled={disabled || loading}
	class:disabled={disabled || loading}
>
	<span class="border-animation"></span>
	<span class="content">
		{#if loading}
			<span class="spinner"></span>
		{/if}{@render children()}
	</span>
</button>

<style>
	button {
		position: relative;
		display: inline-flex;
		overflow: hidden;
		background: none;
		border-radius: 0.75rem;
		border: none;
		padding: 1px;
		cursor: pointer;

		.border-animation {
			position: absolute;
			inset: -10000%;
			background: conic-gradient(var(--bg) 50%, var(--bg) 50%, bisque 100%);
			animation: spin 2.5s linear infinite;
		}

		.content {
			position: relative;
			display: inline-flex;
			height: 100%;
			width: 100%;
			align-items: center;
			justify-content: center;
			border-radius: 0.75rem;
			background-color: var(--bg);
			padding: 0.5rem 1rem;
			font-size: 1rem;
			/* font-weight: 500; */
			color: var(--text-light);
		}
	}
	button:hover {
		transform: scale(1.02);
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
