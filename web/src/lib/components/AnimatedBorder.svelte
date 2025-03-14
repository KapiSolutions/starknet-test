<script lang="ts">
	import type { Snippet } from 'svelte'

	type Props = {
		children: Snippet
		radius?: string
		duration?: number
		color?: string
	}
	let { children, radius = '0.5rem', duration = 5, color = '#909090' }: Props = $props()
</script>

<div style:border-radius={radius}>
	<span
		class="border-animation"
		style:animation-duration="{duration}s"
		style:background="conic-gradient(var(--bg) 50%, var(--bg) 50%, {color} 100%)"
	></span>
	<span class="content">{@render children()} </span>
</div>

<style>
	div {
		position: relative;
		display: inline-flex;
		overflow: hidden;
		background: none;
		border: none;
		padding: 1px;

		.border-animation {
			position: absolute;
			inset: -100000%;
			animation: spin 2s linear infinite;
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
		}
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
