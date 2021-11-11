﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НайденнаяСсылка = Справочники.ЗадачиБухгалтера.НайтиПоКоду("НалогНаИмущество");
	
	Если НайденнаяСсылка <> Неопределено Тогда
		Налог = НайденнаяСсылка;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СтавкиИЛьготы(Команда)
	
	ОткрытьФорму("РегистрСведений.СтавкиНалогаНаИмущество.ФормаСписка");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектыСОсобымПорядкомНалогообложения(Команда)
	
	ОткрытьФорму("РегистрСведений.СтавкиНалогаНаИмуществоПоОтдельнымОсновнымСредствам.ФормаСписка");	
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокУплатыНалоговНаМестах(Команда)
	
	ПараметрыФормы = Новый Структура("Налог", Налог);
	
	ОткрытьФорму("РегистрСведений.ПорядокУплатыНалоговНаМестах.ФормаСписка", ПараметрыФормы, ,Налог);
	
КонецПроцедуры

&НаКлиенте
Процедура СпособыОтраженияРасходов(Команда)
	
	ВидНалога = ПредопределенноеЗначение("Перечисление.ВидыИмущественныхНалогов.НалогНаИмущество");
	ПараметрыФормы = Новый Структура("ВидНалога", ВидНалога);
	
	ОткрытьФорму("РегистрСведений.СпособыОтраженияРасходовПоНалогам.ФормаСписка", ПараметрыФормы, ,ВидНалога);
	
КонецПроцедуры

#КонецОбласти





