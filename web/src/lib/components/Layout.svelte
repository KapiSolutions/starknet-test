<script lang="ts">
	import { type Snippet } from 'svelte'
	import Header from './Header.svelte'
	import ToastContainer from './ToastContainer.svelte'
	import Footer from './Footer.svelte'

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
	<Footer />
</div>

<ToastContainer />

<style>
	.layout {
		display: flex;
		flex-direction: column;
		justify-content: space-between;
		min-height: 100vh;
		width: 100%;
		max-width: 1024px;
		margin: auto;
	}
	main {
		min-height: 80vh;
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
		gap: 1rem;
		background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32' width='32' height='32' fill='none' stroke='rgba(56, 56, 56, 0.678)' %3E%3Cpath d='M0 .5H31.5V32'/%3E%3C/svg%3E");
		background-repeat: repeat;
		background-position: 10%;
		-webkit-mask-image: radial-gradient(circle, rgba(0, 0, 0, 1) 40%, rgba(0, 0, 0, 0) 60%);
		mask-image: radial-gradient(circle, rgba(0, 0, 0, 1) 40%, rgba(0, 0, 0, 0) 60%);

		@media (max-width: 768px) {
			min-height: 75vh;
			-webkit-mask-image: radial-gradient(circle, rgba(0, 0, 0, 1) 70%, rgba(0, 0, 0, 0) 90%);
			mask-image: radial-gradient(circle, rgba(0, 0, 0, 1) 70%, rgba(0, 0, 0, 0) 90%);
		}
	}
</style>
