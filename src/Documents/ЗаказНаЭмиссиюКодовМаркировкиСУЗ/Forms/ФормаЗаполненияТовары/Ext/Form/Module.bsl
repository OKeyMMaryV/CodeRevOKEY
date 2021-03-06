
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеДоступностьюЭлементовФорм(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	
	СтруктураРезультата = Новый Структура();
	
	Если ЗаполнятьВидОбуви Тогда
		СтруктураРезультата.Вставить("ВидОбуви", ВидОбуви);
	КонецЕсли;
	
	Если ЗаполнятьСпособВводаВОборот Тогда
		СтруктураРезультата.Вставить("СпособВводаВОборот", СпособВводаВОборот);
	КонецЕсли;
	
	Закрыть(СтруктураРезультата);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФорм

&НаКлиенте
Процедура ЗаполнятьВидОбувиПриИзменении(Элемент)
	
	УправлениеДоступностьюЭлементовФорм(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьСпосовВводаВОборотПриИзменении(Элемент)
	
	УправлениеДоступностьюЭлементовФорм(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеДоступностьюЭлементовФорм(Форма)
	
	Форма.Элементы.СпособВводаВОборот.ТолькоПросмотр = Не Форма.ЗаполнятьСпособВводаВОборот;
	Форма.Элементы.ВидОбуви.ТолькоПросмотр           = Не Форма.ЗаполнятьВидОбуви;
	
КонецПроцедуры

#КонецОбласти