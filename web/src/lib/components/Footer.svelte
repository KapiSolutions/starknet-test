<script lang="ts">
	import GithubIcon from '../icons/GithubIcon.svelte'
</script>

<footer class="container">
	<a
		class="git"
		href="https://github.com/KapiSolutions/starknet-test"
		rel="noopener noreferrer"
		target="_blank"
	>
		<GithubIcon fill="var(--text-light)" /> <code>Github</code>
	</a>
</footer>

<style>
	.container {
		display: flex;
		flex-direction: column;
		align-items: center;
		padding: 1rem;
	}
	.git {
		display: flex;
		align-items: center;
		justify-content: center;
		gap: 4px;
		text-decoration: none;
		color: var(--text-light);
		opacity: 0.8;
		&:hover {
			opacity: 1;
		}
	}
	footer {
		display: flex;
		align-items: center;
		justify-content: center;
		gap: 1rem;
		width: 100%;
		padding: 1rem;
		@media (max-width: 768px) {
			flex-direction: column;
			text-align: center;
		}
	}
</style>
