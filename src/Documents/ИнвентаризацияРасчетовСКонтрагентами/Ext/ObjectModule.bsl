﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ
//

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнениеДокументов.Заполнить(ЭтотОбъект, ДанныеЗаполнения);
	
	// Заполним табличную часть СчетаРасчетов
	ТаблицаСчетов = УчетВзаиморасчетов.ПолучитьТаблицуСчетовУчетаВзаиморасчетов(Истина, Ложь);
	НоваяСтрокаСчета = ТаблицаСчетов.Добавить();
	НоваяСтрокаСчета.СчетРасчетов = ПланыСчетов.Хозрасчетный.ФинансовыеВложения;
	ТаблицаСчетов.Колонки.Добавить("УчаствуетВРасчетах");
	ТаблицаСчетов.ЗаполнитьЗначения(Истина, "УчаствуетВРасчетах");
	ЭтотОбъект.СчетаРасчетов.Загрузить(ТаблицаСчетов);
    	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Дата 		  = НачалоДня(ОбщегоНазначения.ТекущаяДатаПользователя());
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	Документы.ИнвентаризацияРасчетовСКонтрагентами.ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты, Неопределено, Ложь);

КонецПроцедуры
#КонецЕсли