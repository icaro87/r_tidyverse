# ================ FUNCOES BASICAS DO PACOTE LUBRIDATE


# pacotes -----------------------------------------------------------------


library(lubridate)
library(dplyr)
library(magrittr)
library(nycflights13)
library(stringr)


# base de dados -----------------------------------------------------------


# base de dados voos
df <- nycflights13::flights


# criando data e hora -----------------------------------------------------


# obtendo data de uma var datetime ou data/hora
df %>% transmute(datas = lubridate::date(df$time_hour))

# hoje
today()

# agora
now()


# a partir de strings -----------------------------------------------------


ymd(today()) # ano-mes-dia de hoje

ymd(20250718, tz = "UTC") # ano-mes-dia de uma data em numeros

mdy("January 31st, 2017") # mes-dia-ano de string/texto

dmy("31-Jan-2017") # dia-mes-ano de uma string/texto


# a partir de componentes individuais -------------------------------------


df %>% 
  select(year, month, day, hour, minute) %>% 
  mutate(
    departure = make_datetime(year, month, day, hour, minute)
  )


# a partir de outros tipos ------------------------------------------------


as_datetime(today())

as_datetime(now())

as_datetime(60*60*10)

as_date(360*10+2)


# intervalos --------------------------------------------------------------


h_age <- today() - ymd(19791014)

as.duration(h_age)

dyears(1) + dweeks(12) + dhours(15) # duracao de um ano, 12 semanas e 15 horas

dyears(1) / ddays(50)

