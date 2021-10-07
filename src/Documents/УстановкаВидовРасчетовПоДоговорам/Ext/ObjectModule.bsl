﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	Для Каждого ТекСтрокаПринадлежности Из Принадлежности Цикл
		// регистр УстановкаВидовРасчетовПоДоговорам 
	//	Движения.УстановкаВидовРасчетовПоДоговорам.Очистить();
		Движение = Движения.УстановкаВидовРасчетовПоДоговорам.Добавить();
		Движение.Период = Дата;
		Движение.Организация = Организация;
		Движение.Контрагент = ТекСтрокаПринадлежности.Контрагент;
		Движение.ДоговорКонтрагента = ТекСтрокаПринадлежности.ДоговорКонтрагента;
		Движение.ВидРасчета = ТекСтрокаПринадлежности.ВидРасчета;
	КонецЦикла;
	Движения.УстановкаВидовРасчетовПоДоговорам.Записывать = Истина;
КонецПроцедуры

// 1c-izhtc spawn 14.07.15 (

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("ОткрытиеИзДоговоровКонтрагентов") И ДанныеЗаполнения.ОткрытиеИзДоговоровКонтрагентов Тогда 
		Организация=ДанныеЗаполнения.Организация;
		СтрПринадлежности=Принадлежности.Добавить();
		СтрПринадлежности.ДоговорКонтрагента=ДанныеЗаполнения.Ссылка;
		СтрПринадлежности.Контрагент=ДанныеЗаполнения.Владелец;
	КонецЕсли;
КонецПроцедуры

// 1c-izhtc spawn 14.07.15 )