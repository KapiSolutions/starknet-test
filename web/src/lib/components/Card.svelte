<script lang="ts">
	import type { Snippet } from "svelte"

	type Props = {
		children: Snippet
	}

	let { children }: Props = $props()
</script>

<div class="card">{@render children()}</div>

<style>
	.card {
		background: var(--bg-dimmed);
		border-radius: var(--radius-sm);
		box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
		padding: 1rem;
		display: flex;
		flex-direction: column;
		place-items: center;
	}
</style>
