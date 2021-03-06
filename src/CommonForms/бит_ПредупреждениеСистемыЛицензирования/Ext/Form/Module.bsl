
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Параметры.Ключ) Тогда
		ТекстОшибки = НСтр("ru = 'Общая форма ""Предупреждение системы лицензирования БИТ.ФИНАНС"" является вспомогательной и открывается из служебных механизмов программы.'");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;

	ТекущаяВерсия        = " " + Параметры.ТекущаяВерсия;
	ПоддерживающаяВерсия = Параметры.ПоддерживающаяВерсия;
	ПредставлениеОбъекта = Параметры.ПредставлениеОбъекта;
	
	Элементы.ДекорацияПоддерживающаяВерсия.Заголовок = ПоддерживающаяВерсия;
	
	КлючНазначенияИспользования = Параметры.Ключ;
	КлючСохраненияПоложенияОкна = Параметры.Ключ;

	Элементы.ДекорацияИзменитьВерсию.Видимость = бит_ПолныеПрава.ДоступностьОбщихНастроек();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияИзменитьВерсиюНажатие(Элемент)
	
	Закрыть();
	ОткрытьФорму("ОбщаяФорма.бит_КонстантыУправляемая"); 
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияГиперСсылкаНажатие(Элемент)
	
	ФайловаяСистемаКлиент.ЗапуститьПрограмму("http://www.bitfinance.ru/products/");
	
КонецПроцедуры

#КонецОбласти
