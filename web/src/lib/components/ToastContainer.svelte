<script lang="ts">
	import { toasts } from "../stores/toastStore"
	import Toast from "./Toast.svelte"
</script>

<div class="container">
	{#each $toasts as toast (toast.id)}
		<Toast
			message={toast.message}
			type={toast.type}
			duration={toast.duration}
			onRemove={() => toasts.remove(toast.id)}
		/>
	{/each}
</div>

<style>
	.container {
		position: fixed;
		bottom: 1rem;
		left: 1rem;
		z-index: 1000;
	}
</style>
