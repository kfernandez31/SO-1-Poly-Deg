## Testy rocznikowe
https://gitlab.com/mimuw-rocznik-2001/so-2022/testy-zad1

## Testy oficjalne
https://github.com/kfernandez31/SO-1-PolyDeg/blob/master/test.c

## Opis wyników

Jest 15 testów. Dane testowe umieszczone są na końcu tego pliku.
Za każdy test zakończony poprawnym wynikiem otrzymuje się 1/3 punktu.
Od tego wyniku odejmowane są następujące kary:

  * 1 pkt za błędną nazwę pliku,
  * 1 pkt za błędy wykryte przez valgrind,
  * 0,2 pkt. za użycie instrukcji div lub idiv,
  * 0,1 pkt. za użycie rejestru rax zamiast eax do zwracania wyniku,
  * 0,5 pkt. za zmodyfikowanie wartości w którymś z rejestrów rbx, rbp, r12,
    r13, r14, r15,
  * 1 pkt za zmodyfikowanie tablicy y,
  * min(max((code_size - 192) / 512, 0), 1), gdzie code_size to łączny rozmiar
    kodu, czyli sekcji text i rodata,
  * min(data_size / 128, 1), gdzie data_size to łączny rozmiar danych
    globalnych, czyli sekcji data i bss,
  * 0,1 do 1 punktu za jakość kodu.

W komentarzu do oceny podany jest skrótowy opis wyników. W polu testy wymienione
są numery testów, które nie przeszły. W nawiasie podany jest kod błędu:

  * 1   – błędnie obliczony stopień wielomianu,
  * 123 – valgrind wykrył błąd,
  * 124 – przekroczenie czasu 4 s,
  * 139 – naruszenie ochrony pamięci.

Następnie wypisany jest ułamek testów, które zakończyły się poprawnym wynikiem.
Wypisanie nazwy rejestru oznacza, że nie zachowano reguł użycia tego rejestru.
Napis non-const oznacza, że zmodyfikowano tablicę y.
Na koniec wypisane są rozmiary kodu i danych globalnych.

Ocena jest zaokrąglana w dół do 0,1 punktu, ale nie jest ujemna.
