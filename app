import telebot
from config import keys, TOKEN
from extensions import ConvertiоnException, GetPrice

bot = telebot.TeleBot(TOKEN)

@bot.message_handler(commands=['start', 'help'])
def help(message: telebot.types.Message):
    text = "Чтобы начать работу введите комманду боту в слудеющем формате:\n имя валюты, \
в какую валюту перевести, \
количество переводимой валюты \n Увидеть список всех доступных валют: /values"
    bot.reply_to(message, text)


@bot.message_handler(commands=['values'])
def values(message: telebot.types.Message):
    text = 'Доступные валюты:'
    for key in keys.keys():
        text = '\n'.join((text, key, ))
    bot.reply_to(message, text)

@bot.message_handler(content_types=['text', ])
def convert(message: telebot.types.Message):
    try:
        values = message.text.split(' ')

        if len(values) != 3:
            raise ConvertiоnException('Слишком много параметров.')

        quote, base, amount = values
        total_base = GetPrice.get_price(quote, base, amount)

    except ConvertiоnException as e:
        bot.reply_to(message, f"Ошибка пользователя\n{e}")
    except Exception as e:
        bot.reply_to(message, f"Не удалось обработать каманду\n{e}")

    else:
        total_total_base = total_base * float(amount)
        text = f'Цена {amount} {quote} в {base} - {total_total_base}'
        bot.send_message(message.chat.id, text)


bot.polling()
