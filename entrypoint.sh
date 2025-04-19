#!/bin/bash

# Si no se pasa ningún argumento o se pasa "bash", iniciar shell interactiva
if [ -t 0 ] && { [ -z "$1" ] || [ "$1" = "bash" ]; }; then
    echo "Iniciando una shell interactiva..."
    exec /bin/bash
fi

case "$1" in
    bashate|hadolint|yamllint|markdownlint)
        exec "$@"
        ;;
    --version)
        echo "Versiones de las herramientas:"
        echo "  bashate: $(bashate --version 2>&1)"
        echo "  hadolint: $(hadolint --version)"
        echo "  yamllint: $(yamllint --version)"
        echo "  markdownlint: $(markdownlint --version 2>/dev/null || echo 'markdownlint-cli instalado')"
        exit 0
        ;;
    --help)
        echo "Contenedor de Linters"
        echo "Este contenedor proporciona herramientas para analizar scripts Bash, Dockerfiles, archivos YAML y Markdown."
        echo ""
        echo "Comandos disponibles:"
        echo "  bashate       - Analiza scripts Bash (.sh o scripts con #!/bin/bash)"
        echo "  hadolint      - Analiza Dockerfiles (Dockerfile o *.dockerfile)"
        echo "  yamllint      - Analiza archivos YAML (.yaml, .yml)"
        echo "  markdownlint  - Analiza archivos Markdown (.md, .markdown)"
        echo "  version       - Muestra las versiones de las herramientas instaladas"
        echo "  help          - Muestra este mensaje de ayuda"
        echo "  bash          - Inicia una shell interactiva"
        echo ""
        echo "Uso:"
        echo "  docker run -v \$(pwd):/src <imagen> <comando> [argumentos...]"
        echo ""
        echo "Configuración:"
        echo "  Los linters detectan automáticamente archivos de configuración en el directorio de trabajo (/src):"
        echo "    bashate: .bashaterc"
        echo "    hadolint: .hadolint.yaml"
        echo "    yamllint: .yamllint, .yamllint.yaml"
        echo "    markdownlint: .markdownlint.json, .markdownlint.yaml"
        echo "  Usa --config para especificar archivos de configuración personalizados."
        echo ""
        echo "Ejemplos:"
        echo "  docker run -v \$(pwd):/src <imagen> bashate script.sh"
        echo "  docker run -v \$(pwd):/src <imagen> hadolint --config .hadolint.yaml Dockerfile"
        echo "  docker run -v \$(pwd):/src <imagen> yamllint --strict config.yaml"
        echo "  docker run -v \$(pwd):/src <imagen> markdownlint --disable MD013 README.md"
        echo "  docker run -v \$(pwd):/src <imagen> version"
        echo "  docker run -it -v \$(pwd):/src <imagen>  # Inicia una shell interactiva"
        echo "  docker run -it -v \$(pwd):/src <imagen> bash  # También inicia una shell interactiva"
        exit 0
        ;;
    *)
        echo "Error: Comando desconocido: '$1'"
        echo "Uso: $0 {bashate|hadolint|yamllint|markdownlint|version|help|bash} [argumentos...]"
        echo "O inicia una shell interactiva: docker run -it <imagen> [bash]"
        exit 1
        ;;
esac