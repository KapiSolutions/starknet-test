<script lang="ts">
	import Card from "./lib/components/Card.svelte"
	import Layout from "./lib/components/Layout.svelte"
	import { walletStore } from "./lib/stores/walletStore"
</script>

<Layout>
	{#if $walletStore}
		<Card>
			✨
			<h4>Network</h4>
			<br />
			<code
				><p>ChainId: {$walletStore.provider?.provider?.chainId ?? "Not available"}</p>
				<p>NodeUrl: {$walletStore.provider?.provider?.nodeUrl ?? "Not available"}</p></code
			>
		</Card>
	{/if}
</Layout>
