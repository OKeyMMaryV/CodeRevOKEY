﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Процедура копирует счета из бюджета источника в бюджет приемник.
//
// Параметры:
//  Источник - СправочникСсылка.бит_Бюджеты	 - Ссылка на бюджет источник копирования.
//  Приемник - СправочникСсылка.бит_Бюджеты	 - Ссылка на бюджет приемник.
//
Процедура СкопироватьСчета(Источник, Приемник) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Владелец", Источник);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	бит_СчетаБюджета.Родитель КАК Родитель,
	|	бит_СчетаБюджета.ЭтоГруппа КАК ЭтоГруппа,
	|	бит_СчетаБюджета.Наименование КАК Наименование,
	|	бит_СчетаБюджета.Счет КАК Счет,
	|	бит_СчетаБюджета.НаименованиеПолное КАК НаименованиеПолное,
	|	бит_СчетаБюджета.Коэффициент КАК Коэффициент,
	|	бит_СчетаБюджета.Кодификатор КАК Кодификатор,
	|	бит_СчетаБюджета.НеОтображать КАК НеОтображать,
	|	бит_СчетаБюджета.Комментарий КАК Комментарий,
	|	бит_СчетаБюджета.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.бит_СчетаБюджета КАК бит_СчетаБюджета
	|ГДЕ
	|	бит_СчетаБюджета.Владелец = &Владелец
	|	И НЕ бит_СчетаБюджета.ПометкаУдаления";
	Результа = Запрос.Выполнить();
	
	РодителиЭлементов = Новый Соответствие();
	РодителиЭлементов.Вставить(Справочники.бит_СчетаБюджета.ПустаяСсылка(), Справочники.бит_СчетаБюджета.ПустаяСсылка()); 
	Выборка = Результа.Выбрать();
	
	НачатьТранзакцию();
	Пока Выборка.Следующий() Цикл
		Если Выборка.ЭтоГруппа Тогда
			ИсключенныеСвойства = "НаименованиеПолное, НеОтображать, Комментарий, Ссылка, Счет";
			НовыйСчет = Справочники.бит_СчетаБюджета.СоздатьГруппу();
		Иначе 	
			ИсключенныеСвойства = "Ссылка";
			НовыйСчет = Справочники.бит_СчетаБюджета.СоздатьЭлемент();
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(НовыйСчет, Выборка,, ИсключенныеСвойства);
		НовыйСчет.Владелец = Приемник;
		
		Если ЗначениеЗаполнено(Выборка.Родитель) Тогда
			КопияРодитель = РодителиЭлементов.Получить(Выборка.Родитель);
			Если КопияРодитель = Неопределено Тогда
				КопияРодитель = Справочники.бит_СчетаБюджета.ПолучитьСсылку();
				РодителиЭлементов.Вставить(Выборка.Родитель, КопияРодитель);
			КонецЕсли;	
			НовыйСчет.Родитель = КопияРодитель;
		КонецЕсли;
		
		Если Выборка.ЭтоГруппа Тогда
			НоваяСсылка = РодителиЭлементов.Получить(Выборка.Ссылка);
			Если НоваяСсылка = Неопределено Тогда
				НоваяСсылка = Справочники.бит_СчетаБюджета.ПолучитьСсылку();
				РодителиЭлементов.Вставить(Выборка.Ссылка, НоваяСсылка);
			КонецЕсли; 
			НовыйСчет.УстановитьСсылкуНового(НоваяСсылка);
		КонецЕсли;
		НовыйСчет.УстановитьНовыйКод();
		Попытка
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(НовыйСчет, Истина);
		Исключение
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось копировать счета бюджета.
										|%1'"); 
			ТекстСообщения = СтрШаблон(ТекстСообщения, КраткоеПредставлениеОшибки(ИнформацияОбОшибке())); 
			ВызватьИсключение ТекстСообщения;
		КонецПопытки;
	КонецЦикла;
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли