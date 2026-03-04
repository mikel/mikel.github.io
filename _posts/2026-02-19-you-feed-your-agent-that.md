---
title: "You feed your agent that!?"
author: Mikel Lindsaar
date: 2026-02-19
layout: home
---

Here's a question worth asking: what is your AI agent actually reading when it fetches a web page?

Not the content you care about. The content. All of it. The nav bar. The cookie banner. The JavaScript that populates the dropdown menus. The ads. The footer links. The analytics scripts. The tracking pixels. Every byte of HTML markup wrapping the 800 words of actual information you needed.

A typical documentation page, fetched raw, costs your agent somewhere between 12,000 and 20,000 tokens. The useful information inside it is usually 800 to 1,500 tokens. The rest is noise, and your LLM is billing you to read every character of it.

I ran the numbers. Across the agents I've been building, raw HTML fetch is burning between 57% and 92% of tokens on content that contributes nothing to the output. That's not a rounding error. That's the majority of your API bill going to pay for nav bars.

---

## What the garbage actually looks like

To be concrete about it, here's what a fetch to the Python docs looks like without any processing:

- Raw HTML response: approximately 18,400 tokens
- Useful content (the actual documentation): approximately 1,200 tokens
- Token waste: 93%

That 18,400-token call to Claude 3.5 Sonnet costs roughly $0.055. The same call through a proxy that strips the HTML and returns clean markdown costs around $0.004. If your agent is fetching 100 pages per day, that's the difference between a $5.50/day bill and a $0.40/day bill. At scale, this is not a small number.

The reason this happens is straightforward. HTML was designed for browsers, not language models. Browsers ignore the markup and render the content. LLMs read everything, tokenize everything, and charge you for everything. Your agent is essentially paying to read assembly code when it could be reading a book.

---

## The fix is one line of curl

The solution is to route fetches through a proxy that converts HTML to markdown before the content hits your LLM. That proxy is [Distil, Inc.](https://distil.net).

Here's what that looks like:

```bash
curl -H "X-Distil-Key: YOUR_KEY" \
 https://proxy.distil.net/https://docs.python.org/3/library/json.html
```

You get back clean markdown. Headings, code blocks, paragraphs. No scripts, no nav, no cookie banners. The same documentation content, ready for an LLM to actually use, at a fraction of the token count.

The response includes an `X-Distil-Savings` header that tells you exactly how many tokens were saved on that call. First time I saw it on a real fetch I thought it was miscalculated. It wasn't.

---

## The part that's actually interesting: shared cache

Here's where it gets worth thinking about.

Distil maintains a shared cache across all agents using the service. When any agent fetches a URL, the converted markdown is cached and available to every other agent. Not cached per-account; cached across the network.

This matters because AI agents, at the aggregate level, are reading a lot of the same content. The Python docs. The OpenAI API reference. The GitHub README for every major library. When one agent converts that content, every subsequent agent gets it in under 50ms, preconverted, at no additional processing cost.

The distil dashboard publishes network-wide stats in real time, including cache hit rate, pages fetched, and total tokens saved across all agents.

This is the thing you cannot build for yourself. You could run your own HTML-to-markdown converter, and several exist. But your private cache only benefits your agents. The shared cache means every agent on the network is, collectively, doing the pre-processing work for everyone else. The more agents use it, the higher the hit rate, the cheaper and faster it gets for everyone.

---

## MCP: drop it into Claude Desktop or Cursor in 30 seconds

If you're using Claude Desktop, Cursor, Windsurf, or any MCP-compatible tool, there's a first-party MCP server:

```text
https://proxy.distil.net/mcp
```

Use it as a remote MCP endpoint with a bearer token (`dk_...`). You get tools including `fetch`, `search`, `screenshot`, `render`, `raw`, and `nocache`. Every web fetch goes through the proxy automatically. No code changes.

No npm wrapper is required.

---

## Compared to the obvious alternatives

Jina Reader does something similar, and they've been doing it since April 2024. If you know about them, you're probably wondering what the difference is.

A few things:

First, the shared cache. Jina caches per-user. Distil caches across the network. For AI agents reading common documentation, the hit rates are materially different.

Second, the MCP server. Jina has API endpoints; Distil has a first-party remote MCP endpoint at `https://proxy.distil.net/mcp`. For Claude Desktop users, that's a real UX difference.

Third, proxy mode. You can set `HTTPS_PROXY` to point at distil, and every HTTP call in your agent framework routes through it without any code changes. I'm not aware of another service in this space that offers that.

Fourth, fallback behavior. If distil can't deliver markdown, it can return raw HTML passthrough rather than an error. Your agent keeps working; it just pays more for that call. No dropped requests.

---

## What's available today

- HTTP proxy: works with curl, any HTTP client, any framework
- Converts HTML, PDFs, SPAs, and screenshots to markdown
- Web search that returns markdown results instead of raw HTML
- Site change monitoring with markdown fetch on update
- MCP server: `https://proxy.distil.net/mcp` (Claude Desktop, Cursor, Windsurf, anything MCP-compatible)
- OpenClaw skill: `npx clawhub@latest install distil`
- ROI calculator at [distil.net](https://distil.net/#roi) so you can estimate your own savings before committing to anything

---

## Pricing

50 free credits per month to start. Add a card to unlock Hobby (100 credits/month + screenshots), then scale with paid plans and top-ups as needed.

The first thing I'd suggest: sign up, make one fetch through the proxy, and look at the `X-Distil-Savings` header. That number will either be interesting to you or it won't. If your agents are reading the web at any scale, it will be interesting.

---

## Try it

[https://distil.net/signup](https://distil.net/signup)

No pressure. 50 free credits, no card, one curl command to see if the numbers make sense for your use case. If they do, great. If not, you've spent five minutes and learned something about where your token budget is actually going.
