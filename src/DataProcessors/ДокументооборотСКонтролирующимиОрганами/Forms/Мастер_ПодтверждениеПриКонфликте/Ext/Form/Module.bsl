﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("КриптопровайдерПриКонфликте", КриптопровайдерПриКонфликте);
	
	Если ЗначениеЗаполнено(КриптопровайдерПриКонфликте) Тогда
		Элементы.КриптопровайдерПриКонфликте.Видимость = Ложь;
	КОнецЕсли;
	
	Элементы.КриптопровайдерПриКонфликте.СписокВыбора.Очистить();
	Элементы.КриптопровайдерПриКонфликте.СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыКриптоПровайдеров.CryptoPro"));
	Элементы.КриптопровайдерПриКонфликте.СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ТипыКриптоПровайдеров.VipNet"));

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПродложитьПодключение(Команда)
	
	Если НЕ ЗначениеЗаполнено(КриптопровайдерПриКонфликте) Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Выберите криптопровайдер'"),, "Криптопровайдер");
		Возврат;
	КонецЕсли;
	
	Закрыть(КриптопровайдерПриКонфликте);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти


