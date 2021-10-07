﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки	 - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Функция создает документ Требование-накладная. 
// 
// Параметры:
// 	Основание - ДокументСсылка.бит_мто_ВыдачаТМЦПоЗаявкамНаПотребность.
// 
// Возвращаемое значение:
//   СтрукВоз - Структура.
// 
Функция СоздатьДокументТребованиеНакладная(Основание) Экспорт 

	ДокОб = Документы.ТребованиеНакладная.СоздатьДокумент();
	ДокОб.Дата = ТекущаяДата();
	
	// Заполним реквизиты из стандартного набора по документу основанию.
	ЗаполнениеДокументов.ЗаполнитьПоОснованию(ДокОб, Основание);
	
	ПодразделениеОрганизации = Основание.ЦФО;
	
	ИмяТаблицы	= "Материалы";
	
	ДокОб.Склад = Основание.Склад;
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Склад");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, ДокОб);
	
	Для Каждого ТекСтрокаТовары Из Основание.Товары Цикл
		
		СтрокаТабличнойЧасти                  = ДокОб[ИмяТаблицы].Добавить();
		СтрокаТабличнойЧасти.Номенклатура     = ТекСтрокаТовары.Номенклатура;
		СтрокаТабличнойЧасти.Количество       = ТекСтрокаТовары.Количество;
		СтрокаТабличнойЧасти.ЕдиницаИзмерения = ТекСтрокаТовары.ЕдиницаИзмерения;
		
		Если ИмяТаблицы	= "Материалы" Тогда
			СтрокаТабличнойЧасти.ОтражениеВУСН = Перечисления.ОтражениеВУСН.Принимаются;
		КонецЕсли;
		
	КонецЦикла;
	
	СчетаУчетаВДокументах.ЗаполнитьПередОтображениемПользователю(ДокОб);
	
	Успешно = бит_ОбщегоНазначения.ЗаписатьПровестиДокумент(ДокОб, РежимЗаписиДокумента.Запись);
	
	Если Успешно Тогда
		
		// Заполнение дополнительных аналитик шапки
		Отбор = Новый Структура("Объект", ДокОб.Ссылка);
		НаборЗаписейАналитики = бит_ОбщегоНазначения.ПрочитатьНаборАналитики(Отбор);
		бит_ОбщегоНазначения.ДобавитьЗаписьАналитик(НаборЗаписейАналитики, ДокОб.Ссылка, "ЗаявкаНаПотребность", Основание.ДокументОснование);
		бит_ОбщегоНазначения.ЗаписатьНаборЗаписейРегистра(НаборЗаписейАналитики, "Нет");
		
		// Установка запрета на автоматическое перезаполнение аналитик.
		СтруктураПараметров = Новый Структура("ЗапретитьПерезаполнениеАналитик", Истина);
		бит_МеханизмДопИзмерений.ЗаписатьДополнительныеПараметрыОбъекта(ДокОб.Ссылка, СтруктураПараметров);
		
		СтрукВоз = Новый Структура("Ссылка", ДокОб.Ссылка);
		
		Возврат СтрукВоз;
	
	КонецЕсли; 
	
КонецФункции // СоздатьДокументТребованиеНакладная()

// Функция создает документ ПеремещениеТоваров. 
// 
// Параметры:
// 	Основание - ДокументСсылка.бит_мто_ВыдачаТМЦПоЗаявкамНаПотребность.
// 
// Возвращаемое значение:
//   СтрукВоз - Структура.
// 
Функция СоздатьДокументПеремещениеТоваров(Основание) Экспорт 

	ДокОб = Документы.ПеремещениеТоваров.СоздатьДокумент();
	ДокОб.Дата = ТекущаяДата();
	
	// Заполним реквизиты из стандартного набора по документу основанию.
	ЗаполнениеДокументов.ЗаполнитьПоОснованию(ДокОб, Основание);
	
	ДокОб.СкладОтправитель = Основание.Склад;
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Склад");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, ДокОб);
	
	Для Каждого ТекСтрокаТовары Из Основание.Товары Цикл
		
		СтрокаТабличнойЧасти                  = ДокОб.Товары.Добавить();
		СтрокаТабличнойЧасти.Номенклатура     = ТекСтрокаТовары.Номенклатура;
		СтрокаТабличнойЧасти.Количество       = ТекСтрокаТовары.Количество;
		СтрокаТабличнойЧасти.ЕдиницаИзмерения = ТекСтрокаТовары.ЕдиницаИзмерения;
		
	КонецЦикла;
	
	СчетаУчетаВДокументах.ЗаполнитьПередОтображениемПользователю(ДокОб);
	
	Успешно = бит_ОбщегоНазначения.ЗаписатьПровестиДокумент(ДокОб, РежимЗаписиДокумента.Запись);
	
	Если Успешно Тогда
		
		// Заполнение дополнительных аналитик шапки
		Отбор = Новый Структура("Объект", ДокОб.Ссылка);
		НаборЗаписейАналитики = бит_ОбщегоНазначения.ПрочитатьНаборАналитики(Отбор);
		бит_ОбщегоНазначения.ДобавитьЗаписьАналитик(НаборЗаписейАналитики, ДокОб.Ссылка, "ЗаявкаНаПотребность", Основание.ДокументОснование);
		бит_ОбщегоНазначения.ЗаписатьНаборЗаписейРегистра(НаборЗаписейАналитики, "Нет");
		
		// Установка запрета на автоматическое перезаполнение аналитик.
		СтруктураПараметров = Новый Структура("ЗапретитьПерезаполнениеАналитик", Истина);
		бит_МеханизмДопИзмерений.ЗаписатьДополнительныеПараметрыОбъекта(ДокОб.Ссылка, СтруктураПараметров);
		
		СтрукВоз = Новый Структура("Ссылка", ДокОб.Ссылка);
		
		Возврат СтрукВоз;
	
	КонецЕсли; 
	
КонецФункции // СоздатьДокументПеремещениеТоваров()

#КонецОбласти 	
 	
#КонецЕсли
