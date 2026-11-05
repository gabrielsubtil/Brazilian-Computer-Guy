# Imagem de compartilhamento (`assets/social-preview`)

Arte da capa exibida quando o link do repositório é compartilhado no WhatsApp, Telegram, X, LinkedIn, Discord e Slack.

| Arquivo | Uso |
|---|---|
| `social-preview.svg` | Fonte editável (vetor) |
| `social-preview.png` | Arquivo a enviar no GitHub — **1280 × 640**, limite aceito de 1 MB |

## Como aplicar

O GitHub não lê a imagem do repositório automaticamente. Ela precisa ser enviada no painel:

1. Abra **Settings** do repositório.
2. Em **General → Social preview**, clique em **Upload an image…**.
3. Envie `assets/social-preview.png`.
4. Salve e confira compartilhando o link num chat (ou num validador de Open Graph).

## Como editar

As cores e o texto estão no próprio SVG, sem dependências externas. A paleta usada:

| Cor | Papel |
|---|---|
| `#0b1220` / `#101a2e` | fundo |
| `#22c55e` | identidade, "read-only" e validação |
| `#facc15` | autorização e ponto de parada |
| `#3b82f6` | relatório e evidência |
| `#f8fafc` / `#cbd5e1` | tipografia principal |

Para regerar o PNG depois de editar o SVG:

```bash
# requer cairosvg: pip install cairosvg
python3 -c "import cairosvg; cairosvg.svg2png(url='assets/social-preview.svg', write_to='assets/social-preview.png', output_width=1280, output_height=640)"
```
