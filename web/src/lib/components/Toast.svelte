<script lang="ts">
	import { onMount } from "svelte"
	import type { ToastType } from "../stores/toastStore"

	type Props = {
		message: string
		type: ToastType
		duration: number
		onRemove: () => void
	}

	let { message, type, duration = 3000, onRemove }: Props = $props()
	let progressWidth = $state(0)

	onMount(() => {
		const interval = 50
		const step = 100 / (duration / interval)

		const intervalId = setInterval(() => {
			progressWidth = progressWidth + step
			if (progressWidth >= 100) {
				progressWidth = 100
				clearInterval(intervalId)
			}
		}, interval)

		return () => {
			clearInterval(intervalId)
		}
	})
</script>

<div
	class="toast"
	class:success={type === "success"}
	class:error={type === "error"}
	role="alert"
	aria-live="polite"
>
	<div class="content">
		<span>{message}</span>
		<button class="close-btn" onclick={onRemove} aria-label="Dismiss notification">⛌</button>
	</div>
	<div class="progress-bar">
		<div
			class="progress"
			role="progressbar"
			aria-valuemin="0"
			aria-valuemax="100"
			aria-valuenow={progressWidth}
			style:width={`${progressWidth}%`}
		></div>
	</div>
</div>

<style>
	.toast {
		position: relative;
		width: 300px;
		margin: 0.5rem;
		padding: 1rem;
		border-radius: var(--radius-sm);
		box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
		animation: slideIn 0.3s ease-out;
	}

	.success {
		background: var(--bg-dimmed);
		color: var(--text-light);
	}

	.error {
		background: var(--error);
		color: white;
	}

	.content {
		display: flex;
		justify-content: space-between;
		align-items: center;
		gap: 1rem;
	}

	.close-btn {
		background: none;
		border: none;
		color: white;
		font-size: 1rem;
		cursor: pointer;
		padding: 0 0.5rem;
	}
	.close-btn:hover {
		transform: scale(1.1);
	}

	.progress-bar {
		position: absolute;
		bottom: 0;
		left: 0;
		width: calc(100% - 2px);
		left: 1px;
		height: 3px;
		border-radius: 50%;
		background: rgba(255, 255, 255, 0.3);
	}

	.progress {
		height: 100%;
		border-radius: 50%;
		background: rgba(255, 255, 255, 0.803);
		transition: width linear;
	}

	@keyframes slideIn {
		from {
			transform: translateX(-100%);
			opacity: 0;
		}
		to {
			transform: translateX(0);
			opacity: 1;
		}
	}
</style>
