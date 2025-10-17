# ================ FUNCOES BASICAS DO PACOTE DPLYR


# pacotes -----------------------------------------------------------------


library(dplyr)
library(magrittr)
library(nycflights13)
library(stringr)


# base de dados -----------------------------------------------------------


# base de dados voos
df <- nycflights13::flights



# filtrar linhas com o Filter() -------------------------------------------


df %>% filter(month == 1, day == 10) # registros do mes 1 e do dia 10

df %>% filter(month == 1 & day == 10) # registros do mes 1 e do dia 10

df %>% filter(month == 1 | day == 10) # registros do mes 1 ou do dia 10

df %>% filter(month %in% c(1,2)) # registros dos meses 1 e 2

df %>% filter(!(month %in% c(1,2))) # registros diferentes dos meses 1 e 2

df %>% filter(dep_delay < 0 ) # registros de partidas antecipadas ou atrasos negativos

df %>% filter(dep_delay > 0 ) # registros de atrasos de partidas em minutos maior que zero

df %>% filter(is.na(dep_delay)) # registros de atrasos de partidas em branco/nulo

df %>% filter(origin == "EWR") # registros de origem igual a EWR

df %>% filter(str_starts(origin, "E")) # registros de origem que comecam pelo letra E

df %>% filter(str_starts(dest, "E")) # registros de destino que comecam pelo letra E

df %>% filter(time_hour > '2013-02-14 23:59:59') # registros agendados apos 14/02/2013



# ordenar linhas com arrange() --------------------------------------------


df %>% arrange(year, month, day) # ordenando de modo ascendente a base por ano, mes e dia

df %>% arrange(desc(arr_delay)) # ordenando de modo descrescente a base por arr_delay


# selecionar colunas com select() -----------------------------------------


df %>% select(3:6) # selecionando as colunas de 3,4,5,6

df %>% select(year:arr_time) # selecionando as colunas por nome entre year e arr_time

df %>% select(-(year:arr_time)) # selecionando todas as colunas, exceto aquelas entre year e arr_time

df %>% select(starts_with("arr")) # selecionando todas as colunas cujo nome inicia com 'arr'

df %>% select(ends_with("hour")) # selecionando todas as colunas cujo nome termina com 'hour'

df %>% select(contains("time")) # selecionando todas as colunas cujo nome contem 'time'

df %>% select(arr_time, hour, dep_delay, everything()) # ordenando as colunas

df %>% select_at(.vars = vars(contains("time"))) # selecionando todas as colunas cujo nome contem 'time'

df %>% select_at(.vars = vars(starts_with("a"))) # selecionando todas as colunas cujo nome inicia com 'arr'

df %>% select_at(.vars = vars(!starts_with("a"))) # selecionando todas as colunas cujo nome nao inicia com 'arr'

df %>% select_at(.vars = vars(-starts_with("a"))) # selecionando todas as colunas cujo nome nao inicia com 'arr'


# adicionando novas variaveis com o mutate() ------------------------------


# adicionar as novas colunas calculadas - gain, hours e gain_per_hours
df %>% mutate(
  gain = arr_delay - dep_delay,
  hours = air_time / 60,
  gain_per_hour = gain / hours
)

# para manter apenas as novas variaveis criadas
df %>% transmute(
  gain = arr_delay - dep_delay,
  hours = air_time / 60,
  gain_per_hour = gain / hours
)

# exemplo extra com mutate_at(), aplicando transformacao em multiplas colunas
dados %>% 
  mutate_at(
    .vars = vars(!SG_UF:REDE),
    .funs = 
      list(
        ~ as.numeric(
          stri_replace_all_regex(., c("-", "ND"), c("", ""), vectorise_all = FALSE)
        )
      )
  )

# adicionando nova coluna condicional if_else()
df %>% mutate(grupo = if_else(dep_delay < 0, "Negative", "Positivo"))

# adicionando nova coluna condicional case_when()
df %>% mutate(grupo = case_when(dep_delay < 0 ~ "Negative", .default = "Positive"))



# agrupando e desagrupando variaveis --------------------------------------


# adicionando nova coluna de ranqueamento os voos por ano, mes e dia.
## desagrupando e filtrando a primeira linha de cada grupo

df %>% 
  group_by(year, month) %>% 
  mutate(ordem = row_number()) %>% 
  ungroup() %>% 
  mutate(gain = arr_delay - dep_delay) %>% 
  filter(ordem == 1, month == 6)

