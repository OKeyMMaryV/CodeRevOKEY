﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныйПрограммныйИнтерфейс

// Процедура заполняет дополнительные списки.
// 
// Параметры:
//  СписокПараметровНаФорме - СписокЗначений ИЛИ Неопределено.
// 
Процедура ЗаполнитьДополнительныеСписки(СписокПараметровНаФорме) Экспорт
	
	// Список имен параметров СКД, заполняемых пользователем через элементы формы.
	СписокПараметровНаФорме.Добавить("Период"  		, "Период");
	СписокПараметровНаФорме.Добавить("Периодичность", "Периодичность");
	СписокПараметровНаФорме.Добавить("Бюджет"		, "Бюджет");
		
	// Список дополнительных свойств.
	// фСписокДополнительныхСвойств.Добавить("ДопСвойство");

КонецПроцедуры // ЗаполнитьДополнительныеСписки()

#КонецОбласти
 
#КонецЕсли
