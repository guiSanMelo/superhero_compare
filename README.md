# 🦸‍♂️ SuperHero Compare

**Comparação épica de super-heróis** — Projeto de Desenvolvimento Mobile (2026.1) - ICEV

---

## 📱 Sobre o Projeto

SuperHero Compare é um aplicativo mobile desenvolvido em **Flutter** que permite aos usuários:

- Explorar uma vasta lista de super-heróis
- Buscar heróis por nome
- Selecionar **dois heróis** e compará-los lado a lado
- Visualizar informações detalhadas de cada personagem

Perfeito para quem ama quadrinhos, filmes e quer saber quem venceria em um duelo entre seus heróis favoritos!

## ✨ Funcionalidades

- Infinite Scroll com carregamento progressivo
- Busca em tempo real com debounce
- Modo Duelo (seleção de até 2 heróis)
- Comparação detalhada (poderes, biografia, aparência, etc.)
- Design clean e temático com estilo "comic book"
- Integração com **Supabase** (autenticação e banco)
- Consumo de API de super-heróis

## 🛠 Tecnologias Utilizadas

- **Flutter** (Dart)
- **Supabase Flutter**
- **HTTP** para consumo de API
- Arquitetura limpa com separação de concerns

## 🚀 Como Rodar o Projeto no Celular Físico

### 1. Ative a Depuração USB no seu celular

1. Abra as **Configurações** do celular
2. Vá em **Sobre o telefone** (ou Informações do dispositivo)
3. Toque várias vezes (7x) no **Número da compilação** até aparecer "Você agora é um desenvolvedor!"
4. Volte e procure por **Opções do desenvolvedor**
5. Ative a opção **Depuração USB**

### 2. Conecte o celular no computador

- Conecte o celular via cabo USB
- No celular, autorize a depuração USB quando a mensagem aparecer
- Confie neste computador (se for a primeira vez)

### 3. Execute o app

Abra o terminal na pasta do projeto e rode:

```bash
# Entre na pasta do projeto
cd superhero_compare

# Instale as dependências
flutter pub get

# Verifique se o celular foi detectado
flutter devices
```

Você deve ver seu celular listado. Agora rode o aplicativo:

```bash
# Rode no celular
flutter run
```

### Dicas úteis

- Para modo mais rápido: `flutter run --release`
- Ver logs detalhados: `flutter run -v`
- Se tiver mais de um dispositivo: `flutter run -d SEU_DEVICE_ID`

## 📁 Estrutura de Pastas

```
lib/
├── config/             # Configurações (Supabase)
├── models/             # Modelos de dados
├── navigation/         # Navegação
├── pages/              # Telas do app
├── services/           # Serviços e API
├── shared/             # Componentes reutilizáveis
└── main.dart
```

## 🎯 Próximos Passos

- [ ] Tela de favoritos
- [ ] Filtros avançados (editora, poderes, etc.)
- [ ] Ranking de heróis
- [ ] Modo escuro
- [ ] Compartilhamento de comparações

## 👨‍💻 Autor

**Guilherme Santos de Melo**

**João Antônio Martins de Almeida Alves**

**Laura Maria Madeira Borges Teixeira**

**Romerson Claudino Gonsalves Filho**

Projeto acadêmico - ICEV 2026.1
