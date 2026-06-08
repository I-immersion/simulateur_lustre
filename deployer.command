#!/bin/bash
# ════════════════════════════════════════════════
# LUMIIA · Simulateur Lustre · Script de déploiement
# Double-cliquer pour déployer sur GitHub Pages
# (à placer dans le dossier du repo simulateur_lustre)
# ════════════════════════════════════════════════

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

# se place dans le dossier du script (le repo)
cd "$(dirname "$0")" || { echo -e "${RED}❌ Dossier introuvable${NC}"; read -p "Entrée pour fermer..."; exit 1; }

echo ""
echo -e "${BOLD}════════════════════════════════════════${NC}"
echo -e "${BOLD}   LUMIIA · Déploiement Simulateur Lustre ${NC}"
echo -e "${BOLD}════════════════════════════════════════${NC}"
echo ""

if [ ! -f "index.html" ]; then
  echo -e "${RED}❌ index.html introuvable dans ce dossier${NC}"
  echo -e "   Place ce script dans le dossier du repo simulateur_lustre."
  read -p "Entrée pour fermer..."; exit 1
fi

if [ ! -d ".git" ]; then
  echo -e "${RED}❌ Ce dossier n'est pas un repo git${NC}"
  echo -e "   Clone d'abord : git clone https://github.com/I-immersion/simulateur_lustre.git"
  read -p "Entrée pour fermer..."; exit 1
fi

VERSION=$(grep -o 'LUSTRE · v[0-9]*\.[0-9]*' index.html | head -1 | sed 's/LUSTRE · //')
if [ -z "$VERSION" ]; then VERSION="?.?"; fi

echo -e "📄 Version détectée : ${CYAN}${VERSION}${NC}"
echo ""
echo -e "${YELLOW}Message de déploiement :${NC}"
echo -n "> "
read -r COMMIT_MSG
if [ -z "$COMMIT_MSG" ]; then COMMIT_MSG="déploiement ${VERSION}"; fi
echo ""

echo -e "🚀 Envoi sur GitHub..."
git pull origin main --rebase 2>&1
git add -A
git commit -m "[${VERSION}] ${COMMIT_MSG}"

PUSH_RESULT=$(git push -u origin main 2>&1)
PUSH_CODE=$?

if [ $PUSH_CODE -eq 0 ]; then
  echo ""
  echo -e "${GREEN}${BOLD}✅ Déploiement réussi !${NC}"
  echo -e "   App : ${CYAN}https://i-immersion.github.io/simulateur_lustre/${NC}"
  echo -e "   GitHub Pages se met à jour dans ~1-2 minutes."
else
  echo -e "${RED}❌ Erreur :${NC} $PUSH_RESULT"
fi

echo ""
echo -e "${BOLD}════════════════════════════════════════${NC}"
echo ""
read -p "Appuie sur Entrée pour fermer..."
