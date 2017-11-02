/*
 * ------------------------------------
 * Created :       30/09/2017  (fr)
 * Last update :   30/09/2017  (fr)
 * Author(s) : Nicolas Dupont
 * Contributor(s) :
 * Arduino : Uno
 * Arduino 1.8.4 (Ubuntu 16.04.3)
 *-------------------------------------
*/

float ToFahr(float Cel) {
    float res;
    res = ((Cel * (1.8)) + 32);
    return(res);
}

float ToCelcius(float Fah) {
    float res;
    res = ((Fah - 32) / (1.8));
    return(res);
}
