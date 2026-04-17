#!/usr/bin/env node

import * as esbuild from 'esbuild';
import { promises as fs } from 'fs';
import { join } from 'path';

import { fileURLToPath } from 'url';
import { dirname } from 'path';

async function copyDirectoryRecursively(src, dest)
{
	await fs.mkdir(dest, { recursive: true });

	const entries = await fs.readdir(src, { withFileTypes: true });

	await copyDirectoryRecursivelyRaw(src, dest, entries);
}

async function copyDirectoryRecursivelyRaw(src, dest, entries)
{
	for (const entry of entries)
	{
		const srcPath = join(src, entry.name);
		const destPath = join(dest, entry.name);

		await copyItem(srcPath, destPath, entry);
	}
}

async function copyItem(srcPath, destPath, entry)
{
	if (entry.isDirectory())
	{
		await fs.mkdir(destPath, { recursive: true });

		const newEntries = await fs.readdir(srcPath, { withFileTypes: true });
		await copyDirectoryRecursivelyRaw(srcPath, destPath, newEntries);
	}
	else
	{
		await fs.copyFile(srcPath, destPath);
	}
}

async function minfiyCssFiles(cssFiles, minifiedCssFile)
{
	let cssContentRaw = await Promise.all(
		cssFiles.map(f => fs.readFile(f, 'utf8')));

	// Remove all @charset declarations and let esbuild add it if needed
	cssContentRaw = cssContentRaw.map(
		content => content.replace(/@charset\s+["'][^"']+["'];?\s*/gi, ''));

	const cssContent = cssContentRaw.join('\n');

	const stdIn =
	{
		contents: cssContent,
		loader: 'css'
	};

	const parameters =
	{
		stdin: stdIn,
		minify: true,
		outfile: minifiedCssFile
	};

	esbuild.buildSync(parameters);
}

async function minfiyJsFiles(jsFiles, minifiedJsFile)
{
	const jsContentRaw = await Promise.all(
		jsFiles.map(f => fs.readFile(f, 'utf8')));

	const jsContent = jsContentRaw.join('\n');

	const stdIn =
	{
		contents: jsContent,
		loader: 'js',
	};

	const parameters =
	{
		stdin: stdIn,
		minify: true,
		outfile: minifiedJsFile
	};

	esbuild.buildSync(parameters);
}
