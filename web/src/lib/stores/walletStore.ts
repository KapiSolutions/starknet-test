import { writable } from 'svelte/store'
import type { StarknetKitWallet } from '../types/starknetkit'

function createWalletStore() {
	const { subscribe, set, update } = writable<StarknetKitWallet | null>(null)

	return {
		subscribe,
		set,
		update,
		clear: () => {
			set(null)
		}
	}
}

export const walletStore = createWalletStore()
