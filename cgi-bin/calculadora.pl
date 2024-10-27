#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);

# Encabezado html que indica que el código es HTML con codificación UTF-8
print header('text/html', 'UTF-8');

# Obtener la operación del formulario
my $operacion = param('operacion');
my $resultado;

# Procesar la operación si está presente
if ($operacion) {
    # Resolver la expresión usando funciones sin 'eval'
    $resultado = resolver_expresion($operacion);
}

# Definir funciones para operaciones matemáticas básicas
sub sumar { my ($a, $b) = @_; return $a + $b; }
sub restar { my ($a, $b) = @_; return $a - $b; }
sub multiplicar { my ($a, $b) = @_; return $a * $b; }
sub dividir { my ($a, $b) = @_; return $b != 0 ? $a / $b : "Error: División por cero"; }
sub raiz_cuadrada { my ($a) = @_; return $a >= 0 ? sqrt($a) : "Error: Raíz de número negativo"; }

# Función para resolver la expresión
sub resolver_expresion {
    my ($expr) = @_;

    # Eliminar espacios
    $expr =~ s/\s+//g;

    # Evaluar expresiones de raíz cuadrada
    while ($expr =~ /raiz\(([^()]+)\)/) {
        my $sub_expr = $1;
        my $sub_result = resolver_expresion($sub_expr);  # Evaluar dentro de la raíz
        my $raiz_result = raiz_cuadrada($sub_result);
        $expr =~ s/raiz\(\Q$sub_expr\E\)/$raiz_result/;
    }

    # Evaluar primero los paréntesis internos
    while ($expr =~ /\(([^()]+)\)/) {
        my $sub_expr = $1;
        my $sub_result = evaluar_operacion($sub_expr);
        $expr =~ s/\(\Q$sub_expr\E\)/$sub_result/;
    }

    # Evaluar la operación final si no quedan paréntesis
    return evaluar_operacion($expr);
}

# Función para evaluar operaciones simples sin paréntesis
sub evaluar_operacion {
    my ($expr) = @_;

    # Resolver multiplicación y división primero
    while ($expr =~ /(-?\d+(?:\.\d+)?)\s*([\*\/])\s*(-?\d+(?:\.\d+)?)/) {
        my ($left, $op, $right) = ($1, $2, $3);
        my $result = $op eq '*' ? multiplicar($left, $right) : dividir($left, $right);
        $expr =~ s/\Q$left$op$right\E/$result/;
    }

    # Luego resolver suma y resta
    while ($expr =~ /(-?\d+(?:\.\d+)?)\s*([\+\-])\s*(-?\d+(?:\.\d+)?)/) {
        my ($left, $op, $right) = ($1, $2, $3);
        my $result = $op eq '+' ? sumar($left, $right) : restar($left, $right);
        $expr =~ s/\Q$left$op$right\E/$result/;
    }

    return $expr;
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
            <img src="../img/W3C_HTML5_certified.png" alt="Markup Validation" >
        </a>
        <a href="https://jigsaw.w3.org/css-validator/#validate_by_input" class="image-link" target="_blank">
            <img src="../img/Valid_CSS_(blue).svg.png" alt="CSS Validation" >
        </a>
        <a href="https://www.w3.org/WAI/test-evaluate/tools/list/" class="image-link" target="_blank">
            <img src="../img/wcag2.2AAA-blue.png" alt="Web Accessibility" >
        </a>
    </div>
    <div>
        Bedregal Coaguila, Karla Miluska &copy; Laboratorio 06 - Grupo D
    </div>
</footer>
</body>
</html>
HTML


