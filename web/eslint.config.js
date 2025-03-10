import eslint from '@eslint/js'
import svelte from 'eslint-plugin-svelte'
import globals from 'globals'
import tseslint from 'typescript-eslint'

export default tseslint.config(
	eslint.configs.recommended,
	...tseslint.configs.recommended,
	...svelte.configs['flat/recommended'],
	...svelte.configs['flat/prettier'],
	{
		languageOptions: {
			globals: {
				...globals.browser,
				...globals.node
			}
		}
	},
	{
		files: ['**/*.svelte', '*.ts', '*.js'],
		languageOptions: {
			parserOptions: {
				parser: '@typescript-eslint/parser'
			}
		}
	},
	{
		rules: {
			'no-unused-vars': 'off',
			'@typescript-eslint/no-unused-vars': 'warn'
		}
	},
	{
		ignores: ['build/', 'dist/']
	}
)
