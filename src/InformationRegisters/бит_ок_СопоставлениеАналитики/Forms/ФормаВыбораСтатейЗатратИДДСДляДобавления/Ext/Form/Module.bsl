&НаСервере
Функция СформироватьВозвращаемоеЗначение()
	МассивКодовСтатейДДС = Новый Массив;
	Для Каждого текСтрока Из СтатьиДДС Цикл
		Если Не текСтрока.Выбрано Тогда Продолжить; КонецЕсли;
		МассивКодовСтатейДДС.Добавить(текСтрока.Код);
	КонецЦикла;
	
	МассивКодовСтатейЗатрат = Новый Массив;
	Для Каждого текСтрока Из СтатьиЗатрат Цикл
		Если Не текСтрока.Выбрано Тогда Продолжить; КонецЕсли;
		МассивКодовСтатейЗатрат.Добавить(текСтрока.Код);
	КонецЦикла;
	
	Возврат Новый Структура("МассивКодовСтатейДДС,МассивКодовСтатейЗатрат", МассивКодовСтатейДДС, МассивКодовСтатейЗатрат);
КонецФункции

&НаКлиенте
Процедура ОсновныеДействияФормыСоздать(Команда)
	Закрыть(СформироватьВозвращаемоеЗначение());
КонецПроцедуры

&НаСервере
Функция КоманднаяПанель1ВыбратьВсё_Сервер()
	Для каждого Стр из СтатьиЗатрат Цикл
		Стр.Выбрано = Истина;
	КонецЦикла;
КонецФункции


&НаКлиенте
Процедура КоманднаяПанель1ВыбратьВсё(Команда)
	КоманднаяПанель1ВыбратьВсё_Сервер();
КонецПроцедуры

&НаСервере
Функция КоманднаяПанель1СнятьФлажки_Сервер()
	Для каждого Стр из СтатьиЗатрат Цикл
		Стр.Выбрано = Ложь;
	КонецЦикла;
КонецФункции


&НаКлиенте
Процедура КоманднаяПанель1СнятьФлажки(Команда)
	КоманднаяПанель1СнятьФлажки_Сервер();
КонецПроцедуры

&НаСервере
Функция КоманднаяПанель2ВыбратьВсё_Сервер()
	Для каждого Стр из СтатьиДДС Цикл
		Стр.Выбрано = Истина;
	КонецЦикла;
КонецФункции


&НаКлиенте
Процедура КоманднаяПанель2ВыбратьВсё(Команда)
	КоманднаяПанель2ВыбратьВсё_Сервер();

КонецПроцедуры

&НаСервере
Функция КоманднаяПанель2СнятьФлажки_Сервер()
	Для каждого Стр из СтатьиДДС Цикл
		Стр.Выбрано = Ложь;
	КонецЦикла;
КонецФункции


&НаКлиенте
Процедура КоманднаяПанель2СнятьФлажки(Команда)
	КоманднаяПанель2СнятьФлажки_Сервер();
КонецПроцедуры
