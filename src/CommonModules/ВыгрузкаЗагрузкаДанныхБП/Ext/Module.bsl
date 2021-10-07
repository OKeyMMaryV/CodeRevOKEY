﻿#Область ПрограммныйИнтерфейс

// См. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриРегистрацииОбработчиковЗагрузкиДанных
//
Процедура ПриРегистрацииОбработчиковЗагрузкиДанных(ТаблицаОбработчиков) Экспорт
	
	МетаданныеПодписок = ПодпискиЗаписиДанныхПервичныхДокументов();
	
	Для Каждого МетаданныеПодписки Из МетаданныеПодписок Цикл
		Для Каждого ТипИсточника Из МетаданныеПодписки.Источник.Типы() Цикл
			СтрокаОбработчика = ТаблицаОбработчиков.Добавить();
			СтрокаОбработчика.ОбъектМетаданных      = Метаданные.НайтиПоТипу(ТипИсточника);
			СтрокаОбработчика.Обработчик            = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиСобытияБП");
			СтрокаОбработчика.ПередЗагрузкойОбъекта = Истина;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПодпискиЗаписиДанныхПервичныхДокументов()
	
	ИмяОбработчикаДляПоиска = Метаданные.ПодпискиНаСобытия.ЗарегистрироватьДанныеПервичныхДокументов.Обработчик;
	
	МетаданныеПодписок = Новый Массив;
	Для Каждого Подписка Из Метаданные.ПодпискиНаСобытия Цикл
		Если Подписка.Обработчик = ИмяОбработчикаДляПоиска Тогда
			МетаданныеПодписок.Добавить(Подписка);
		КонецЕсли;
	КонецЦикла;
	
	Возврат МетаданныеПодписок;
	
КонецФункции


#КонецОбласти