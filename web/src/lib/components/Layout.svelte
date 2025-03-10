<script lang="ts">
	import { type Snippet } from "svelte"
	import Header from "./Header.svelte"
	import ToastContainer from "./ToastContainer.svelte"

	type Props = {
		children: Snippet
	}
	let { children }: Props = $props()
</script>

<div class="layout">
	<Header />
	<main>
		{@render children()}
	</main>
	<footer></footer>
</div>

<ToastContainer />

<style>
	.layout {
		display: flex;
		flex-direction: column;
		min-height: 100vh;
		width: 100%;
		max-width: 1024px;
		margin: auto;
	}
	main {
		padding: 1rem;
		display: flex;
		flex-direction: column;
		place-items: center;
		gap: 1rem;
	}
</style>
