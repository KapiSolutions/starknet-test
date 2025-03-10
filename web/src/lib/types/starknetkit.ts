import type { StarknetWindowObject } from 'starknetkit'

export type StarknetKitWallet = StarknetKitWallet119 & StarknetWindowObject

// starknetkit v2.3.2
type StarknetKitWallet232 = {
	id: string
	name: string
	icon: string
	account:
		| {
				responseParser: Record<string, unknown>
				channel: {
					nodeUrl: string
					headers: {
						'Content-Type': string
						'argent-version': string
						'argent-client': string
					}
					retries: number
					requestId: number
					blockIdentifier: string
					chainId: string
					waitMode: boolean
				}
				signer: {
					pk: string
				}
				address: string
				transactionVersion: '0x2' | '0x3'
		  }
		| undefined
	provider: {
		responseParser: Record<string, unknown>
		channel: {
			nodeUrl: string
			headers: {
				'Content-Type': string
				'argent-version': string
				'argent-client': string
			}
			retries: number
			requestId: number
			blockIdentifier: string
			chainId: string
			waitMode: boolean
		}
	}
	selectedAddress: string
	chainId: string | undefined
	isConnected: boolean
	version: string
}

// starknetkit v1.1.9
type StarknetKitWallet119 = {
	id: string
	name: string
	icon: string | { dark: string; light: string }
	account: {
		provider: {
			nodeUrl: string
			headers: {
				'Content-Type': string
				'argent-version': string
				'argent-client': string
			}
			responseParser: Record<string, unknown>
			retries: number
			blockIdentifier: string
			chainId: string
		}
		signer: {
			pk: string
		}
		address: string
	}
	provider: {
		provider: {
			nodeUrl: string
			headers: {
				'Content-Type': string
				'argent-version': string
				'argent-client': string
			}
			responseParser: Record<string, unknown>
			retries: number
			blockIdentifier: string
			chainId: string
		}
	}
	selectedAddress: string
	chainId: string
	isConnected: boolean
	version: string
	starknetJsVersion: string
} | null
