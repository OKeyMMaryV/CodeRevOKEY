﻿
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("СтруктурнаяЕдиница", Запись.СтруктурнаяЕдиница);
	
	ОткрытьФорму("Обработка.ПерезаполнениеРегистрацийВНалоговомОргане.Форма", ПараметрыОткрытия, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДатаОтсчетаПериодическихСведений = РегистрыСведений.ИсторияРегистрацийВНалоговомОргане.ДатаОтсчетаПериодическихСведений();
	
	Если Параметры.Ключ.Пустой() Тогда
		Запись.Период = ДатаОтсчетаПериодическихСведений;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсправитьПериод(Команда)
	
	Запись.Период = ДатаОтсчетаПериодическихСведений;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
КонецПроцедуры
