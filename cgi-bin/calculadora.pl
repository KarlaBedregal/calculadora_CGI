#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);
use POSIX qw(floor ceil);

print header();
print start_html("Resultado de la Calculadora");

my $expresion = param('expresion');

# Usar expresiones regulares para reconocer los operandos y el operador
if ($expresion =~ /^\s*([-+]?\d*\.?\d+)\s*([+\-*\/])\s*([-+]?\d*\.?\d+)\s*$/) {
    my $operando1 = $1;
    my $operador = $2;
    my $operando2 = $3;
    my $resultado;

    # Realizar la operación
    if ($operador eq '+') {
        $resultado = $operando1 + $operando2;
    } elsif ($operador eq '-') {
        $resultado = $operando1 - $operando2;
    } elsif ($operador eq '*') {
        $resultado = $operando1 * $operando2;
    } elsif ($operador eq '/') {
        if ($operando2 != 0) {
            $resultado = $operando1 / $operando2;
        } else {
            $resultado = "Error: División por cero";
        }
    }

    print "<h2>Resultado: $resultado</h2>";
} else {
    print "<h2>Error: Expresión no válida</h2>";
}

print end_html();
