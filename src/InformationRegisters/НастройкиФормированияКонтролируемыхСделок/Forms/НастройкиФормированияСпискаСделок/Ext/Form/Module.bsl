﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НастройкиФормированияКонтролируемыхСделок = РегистрыСведений.НастройкиФормированияКонтролируемыхСделок.ПолучитьНастройкиФормированияКонтролируемыхСделок();
	ЗаполнитьЗначенияСвойств(ЭтаФорма, НастройкиФормированияКонтролируемыхСделок);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		
		ЗаписатьНастройки();
		
		Оповестить("Запись_НастройкиФормированияУведомления", Неопределено, Неопределено);
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ЗаписатьНастройки()
	
	НастройкиФормированияКонтролируемыхСделок = РегистрыСведений.НастройкиФормированияКонтролируемыхСделок.ПолучитьНастройкиФормированияКонтролируемыхСделок();
	ЗаполнитьЗначенияСвойств(НастройкиФормированияКонтролируемыхСделок, ЭтаФорма);
	РегистрыСведений.НастройкиФормированияКонтролируемыхСделок.ЗаписатьНастройкиФормированияКонтролируемыхСделок(НастройкиФормированияКонтролируемыхСделок);
	
КонецПроцедуры

