// Pines PWM del DRV8833
const int AIN1 = 6;
const int AIN2 = 10;
const int BIN1 = 9;
const int BIN2 = 11;

const int DATA_PIN = 13;  // Datos
const int CLK_PIN  = 7;  // Reloj
const int LAT_PIN  = 8;  // Latch
const int STB_PIN  = 12; // STB (nueva señal)
const int VDD_PIN = 2; //Vdd

char linea[385] = "111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111";
const int STEPS_PER_REV = 10;
int velocidad = 180;
int delayPaso = 5;

int pasos[8][4] = {
  {1, 0, 0, 1},
  {0, 0, 0, 1},
  {0, 1, 0, 1},
  {0, 1, 0, 0},
  {0, 1, 1, 0},
  {0, 0, 1, 0},
  {1, 0, 1, 0},
  {1, 0, 0, 0}
};

void setup() {
  pinMode(AIN1, OUTPUT);
  pinMode(AIN2, OUTPUT);
  pinMode(BIN1, OUTPUT);
  pinMode(BIN2, OUTPUT);
  pinMode(DATA_PIN, OUTPUT);
  pinMode(CLK_PIN, OUTPUT);
  pinMode(LAT_PIN, OUTPUT);
  pinMode(STB_PIN, OUTPUT);
  pinMode(VDD_PIN, OUTPUT);
  digitalWrite(VDD_PIN, HIGH);

  digitalWrite(CLK_PIN, LOW);
  digitalWrite(LAT_PIN, LOW);
  digitalWrite(STB_PIN, LOW);

  Serial.begin(9600);
  Serial.println("Motor paso a paso con PWM y DRV8833 listo");
}

void loop() {
  enviarLineas();
  girarMotor(true);
  delay(10);
}

// ----------------------
// Módulo de envío
// ----------------------
void enviarLineas() {
  // ----------- pt1 -----------
  enviarPaquete(linea, 0, 64);
  latchPulse();

  // ----------- 5 paquetes de 64 ceros -----------
  for (int i = 0; i < 5; i++) enviarCeros(64);

  // ----------- pt2 -----------
  enviarPaquete(linea, 64, 128);
  enviarCeros(64);
  latchPulse();

  // ----------- 4 paquetes de 64 ceros -----------
  for (int i=0;i<4;i++) enviarCeros(64);

  // ----------- pt3 -----------
  enviarPaquete(linea, 128, 192);
  for (int i=0;i<2;i++) enviarCeros(64);
  latchPulse();

  // ----------- 3 paquetes de ceros -----------
  for (int i=0;i<3;i++) enviarCeros(64);

  // ----------- pt4 -----------
  enviarPaquete(linea, 192, 256);
  for (int i=0;i<3;i++) enviarCeros(64);
  latchPulse();

  // ----------- 2 paquetes de ceros -----------
  for (int i=0;i<2;i++) enviarCeros(64);

  // ----------- pt5 -----------
  enviarPaquete(linea, 256, 320);
  for (int i=0;i<4;i++) enviarCeros(64);
  latchPulse();

  // ----------- 1 paquete de ceros -----------
  enviarCeros(64);

  // ----------- pt6 -----------
  enviarPaquete(linea, 320, 384);
  for (int i=0;i<5;i++) enviarCeros(64);
  latchPulse();
}

// ----------------------
// Envío con reloj
// ----------------------
void enviarPaquete(char *data, int inicio, int fin) {
  for (int i = inicio; i < fin; i++) {
    int bitVal = (data[i] == '1') ? HIGH : LOW;
    digitalWrite(DATA_PIN, bitVal);

    // Pulso de reloj
    digitalWrite(CLK_PIN, HIGH);
    delayMicroseconds(5);
    digitalWrite(CLK_PIN, LOW);
    delayMicroseconds(5);
  }

  // Dormir el reloj
  digitalWrite(CLK_PIN, LOW);
}

void enviarCeros(int cantidad) {
  for (int i = 0; i < cantidad; i++) {
    digitalWrite(DATA_PIN, LOW);

    digitalWrite(CLK_PIN, HIGH);
    delayMicroseconds(5);
    digitalWrite(CLK_PIN, LOW);
    delayMicroseconds(5);
  }

  // Dormir el reloj
  digitalWrite(CLK_PIN, LOW);
}

// ----------------------
// Latch + STB
// ----------------------
void latchPulse() {
  digitalWrite(LAT_PIN, HIGH);
  delayMicroseconds(100);
  digitalWrite(LAT_PIN, LOW);

  // 🔹 Señal STB (ligeramente después del latch)
  delayMicroseconds(50);       // breve retardo después del latch
  digitalWrite(STB_PIN, HIGH); // activar STB
  delayMicroseconds(50);      // mantener activo un corto tiempo
  digitalWrite(STB_PIN, LOW);  // desactivar STB
}

// ----------------------
// Motor
// ----------------------
void girarMotor(bool horario) {
  int paso = (horario) ? 0 : 7;

  for (int i = 0; i < 8; i++) {
    aplicarPaso(pasos[paso]);
    paso = (horario) ? (paso + 1) % 8 : (paso - 1 + 8) % 8;
    delay(delayPaso);
  }
}


void aplicarPaso(int *p) {
  analogWrite(AIN1, p[0] * velocidad);
  analogWrite(AIN2, p[1] * velocidad);
  analogWrite(BIN1, p[2] * velocidad);
  analogWrite(BIN2, p[3] * velocidad);
}
