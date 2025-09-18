# --- ÉTAPE 1 : Étape de construction (Build Stage) ---
# Utilise une image Node.js complète pour la compilation.
FROM node:22-alpine AS builder

# Définition du répertoire de travail.
WORKDIR /app

# Copie des fichiers de configuration et installation des dépendances.
# On installe d'abord les dépendances pour utiliser la mise en cache de Docker.
COPY package*.json ./
RUN npm install

# Copie de tout le code source de l'application.
COPY . .

# Exécution de la compilation de l'application Next.js.
# Cette commande génère les fichiers optimisés pour la production.
RUN npm run build

# --- ÉTAPE 2 : Étape de production (Production Stage) ---
# Utilise une image Node.js Alpine plus légère pour le conteneur final de production.
FROM node:22-alpine AS runner

# Définition du répertoire de travail.
WORKDIR /app

# Copie uniquement les fichiers nécessaires à l'exécution de l'application
# depuis l'étape de construction vers le conteneur final.
COPY --from=builder /app/package.json ./
COPY --from=builder /app/next.config.ts ./
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

# Expose le port par défaut de Next.js.
EXPOSE 3000

# Démarre l'application en mode production.
# Next.js utilise le "standalone output" qui est plus efficace.
CMD ["node", "server.js"]
