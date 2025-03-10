import { writable } from 'svelte/store'

export type ToastType = 'success' | 'error'

export type Toast = {
	id: number
	message: string
	type: ToastType
	duration: number
}

export type ToastOptions = {
	message: string
	type?: ToastType
	duration?: number
}

function createToastStore() {
	const { subscribe, update } = writable<Toast[]>([])
	let toastId = 0
	const timeouts = new Map<number, number>()
	const remove = (id: number) => {
	  const timeout = timeouts.get(id)
	  if (timeout) {
		clearTimeout(timeout)
		timeouts.delete(id)
	  }
	  update((toasts) => toasts.filter((t) => t.id !== id))
	}
	const add = (options: ToastOptions) => {
	  const toast: Toast = {
		id: toastId++,
		message: options.message,
		type: options.type || 'success',
		duration: options.duration || 2500
	  }
	  update((toasts) => [...toasts, toast])
	  const timeout = setTimeout(() => {
		remove(toast.id)
	  }, toast.duration)
	  timeouts.set(toast.id, timeout)
	  return toast.id
	}
	return { subscribe, add, remove }
  }

export const toasts = createToastStore()
