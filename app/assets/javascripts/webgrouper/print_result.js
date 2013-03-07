function printResult() {
    toggleNonResult();
    window.print();
    toggleNonResult();
}

function toggleNonResult() {
    $('#stay').toggle();
    $('#patient-data').toggle();
    $('#drg-proc').toggle();
    $('#buttons').toggle();
}