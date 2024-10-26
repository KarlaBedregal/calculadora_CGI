#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);

print header('text/html', 'UTF-8');

# Obtener la operación del formulario
my $operacion = param('operacion');
my $resultado;

# Procesar la operación
if ($operacion) {
    # Reemplazar 'raiz' por 'sqrt' para permitir la evaluación
    $operacion =~ s/raiz\(([^)]+)\)/sqrt($1)/g;

    eval {
        $resultado = eval $operacion;  # Evaluar la expresión matemática
    };
    
    # Manejar errores en la evaluación
    if ($@) {
        $resultado = "Error en la operación: $@";
    }
}

# Imprimir la salida HTML
print <<HTML;
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resultados de la Calculadora</title>
    <link rel="stylesheet" href="../styles.css">
</head>
<body>

<div class="calculadora">
    <h1>Resultados</h1>
    <form action="/cgi-bin/calculadora.pl" method="GET">
        <input type="text" name="operacion" placeholder="Ingrese: raiz(4) o (4+5)/5" class="pantalla" value="$operacion">
        <div class="resultado">
            <button type="submit" class="calcular">Calcular</button>
        </div>    
    </form>

    <!-- Caja para mostrar el resultado -->
    <div class="resultado-caja">
        <p>$resultado</p>
    </div>
</div>

<!-- Sección de pie de página -->
<footer class="footer">
    <div class="footer-links">
        <a href="https://validator.w3.org/#validate_by_input" class="image-link" target="_blank">
            <img src="../img/W3C_HTML5_certified.png" alt="Markup Validation" />
        </a>
        <a href="https://jigsaw.w3.org/css-validator/#validate_by_input" class="image-link" target="_blank">
            <img src="../img/Valid_CSS_(blue).svg.png" alt="CSS Validation" />
        </a>
        <a href="https://www.w3.org/WAI/test-evaluate/tools/list/" class="image-link" target="_blank">
            <img src="../img/wcag2.2AAA-blue.png" alt="Web Accessibility" />
        </a>
    </div>
    <div>
        Bedregal Coaguila, Karla Miluska &copy; Laboratorio 06 - Grupo D
    </div>
</footer>
</body>
</html>
HTML


