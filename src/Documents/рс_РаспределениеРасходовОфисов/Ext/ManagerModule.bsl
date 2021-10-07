﻿
////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура формирует печатные формы объектов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	//ПечатныйДокумент = СформироватьПечатнуюФормуПротоколРасчета(ИмяМакета, МассивСсылок);
	
	//1С-ИжТиСи, Кондратьев, 03.2020, обновление (
	//Запрос = Новый Запрос;
	//Запрос.Текст =
	//"ВЫБРАТЬ
	//|	рс_ПротоколыРасчета.ПротоколРасчета
	//|ИЗ
	//|	РегистрСведений.рс_ПротоколыРасчета КАК рс_ПротоколыРасчета
	//|ГДЕ
	//|	рс_ПротоколыРасчета.Регистратор В(&МассивСсылок)";
	//Запрос.УстановитьПараметр("МассивСсылок", МассивСсылок);
	//ТаблицаЗапрос = Запрос.Выполнить().Выгрузить();
	//
	//Если ТаблицаЗапрос.Количество() > 0 Тогда
	//	ПечатныйДокумент = ТаблицаЗапрос[0].ПротоколРасчета.Получить();
	//	Если ТипЗнч(ПечатныйДокумент) <> Тип("ТабличныйДокумент") Тогда
	//		ПечатныйДокумент = Новый ТабличныйДокумент;
	//		Возврат;
	//	КонецЕсли;
	//КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПротоколРасчета") Тогда					
		// Формируем табличный документ и добавляем его в коллекцию печатных форм.
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	рс_ПротоколыРасчета.ПротоколРасчета
		|ИЗ
		|	РегистрСведений.рс_ПротоколыРасчета КАК рс_ПротоколыРасчета
		|ГДЕ
		|	рс_ПротоколыРасчета.Регистратор В(&МассивСсылок)";
		Запрос.УстановитьПараметр("МассивСсылок", МассивОбъектов);
		ТаблицаЗапрос = Запрос.Выполнить().Выгрузить();
		
		Если ТаблицаЗапрос.Количество() > 0 Тогда
			ПечатныйДокумент = ТаблицаЗапрос[0].ПротоколРасчета.Получить();
			Если ТипЗнч(ПечатныйДокумент) <> Тип("ТабличныйДокумент") Тогда
				ПечатныйДокумент = Новый ТабличныйДокумент;
			КонецЕсли;
		КонецЕсли;

		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПротоколРасчета", НСтр("ru = 'Протокол расчета'"), 
			ПечатныйДокумент,,"Документ.рс_РаспределениеРасходовОфисов.ПротоколРасчета", НСтр("ru = 'Протокол расчета'"));
	КонецЕсли;
	
	ОбщегоНазначенияБП.ЗаполнитьДополнительныеПараметрыПечати(МассивОбъектов, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	//1С-ИжТиСи, Кондратьев, 03.2020, обновление )

КонецПроцедуры // Печать()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

Функция ПолучитьТаблицуДокументов(МассивСсылок)

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	*
	               |ИЗ
	               |	Документ." + ПустаяСсылка().Метаданные().Имя + " КАК Документы
	               |ГДЕ
	               |	Документы.Ссылка В(&МассивСсылок)";
	Запрос.Параметры.Вставить("МассивСсылок", МассивСсылок);
	Результат = Запрос.Выполнить();
	
	ТаблицаДокументов = Результат.Выгрузить();
	
	Возврат ТаблицаДокументов;
	
КонецФункции // ПолучитьТаблицуДокументов()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ТАБЛИЧНЫХ ДОКУМЕНТОВ
   
Функция СформироватьПечатнуюФормуПротоколРасчета(ИмяМакета, МассивСсылок) Экспорт

	ТабДок = Новый ТабличныйДокумент;
	ТабДок.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_рс_РаспределениеРасходовОфисов_ПротоколРасчета";  	
	
	// Таблица по документам
	ТаблицаДокументов = ПолучитьТаблицуДокументов(МассивСсылок);
	
	Если ТаблицаДокументов.Количество() > 0 Тогда
			
		// Таблица по табличной части
		ТаблицаДокументов = ПолучитьТаблицуДокументов(МассивСсылок);
		
		// Вывод результатов
		ПервыйДокумент   = Истина;
				
		Для каждого СтрДокумент Из ТаблицаДокументов Цикл
					
			// Текущий документ
			ТекДокумент = СтрДокумент.Ссылка.ПолучитьОбъект();
			
			Если ТекДокумент.ВидОперации = Перечисления.рс_ВидыОперацийРаспределениеРасходовОфисов.НаМагазины Тогда
				ИмяМакета = "ПротоколРасчетаНаМагазины";
			Иначе
				ИмяМакета = "ПротоколРасчетаНаТЦ";
			КонецЕсли;
			
			// Получаем макет и области
			Макет = Документы[ПустаяСсылка().Метаданные().Имя].ПолучитьМакет(ИмяМакета);
			ОбластьЗаголовок	= Макет.ПолучитьОбласть("Заголовок");
			ОбластьШапка		= Макет.ПолучитьОбласть("Шапка");
			ОбластьСтрока		= Макет.ПолучитьОбласть("Строка");
			ОбластьПодвал		= Макет.ПолучитьОбласть("Подвал");
			ОбластьИтоги		= Макет.ПолучитьОбласть("Итоги");
			
			// Отбор для таблиц по текущему документу
			Отбор = Новый Структура;
			Отбор.Вставить("Ссылка", ТекДокумент);
											
			// Rarus-spb byse 2012.12.27 {
			// Разделитель страниц
			//1С-ИжТиСи, Кондратьев, 27.03.2020, Обновление (
			//Попытка
			//	бит_ПечатьСервер.ВывестиГоризонтальныйРазделительСтраниц(ТабДок, ПервыйДокумент);
			//Исключение
			//1С-ИжТиСи, Кондратьев, 27.03.2020, Обновление )	
				Если Не ПервыйДокумент Тогда
					ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
				КонецЕсли;  			
				ПервыйОбъект = Ложь;
			//1С-ИжТиСи, Кондратьев, 27.03.2020, Обновление (
			//КонецПопытки;
			//1С-ИжТиСи, Кондратьев, 27.03.2020, Обновление )
			// Rarus-spb byse 2012.12.27 }

			// Заполним общие для документа параметры
			ОбластьЗаголовок.Параметры.Заполнить(СтрДокумент);
			ОбластьЗаголовок.Параметры.Дата = Формат(СтрДокумент.Дата, "ДФ=dd.MM.yyyy");
			ОбластьШапка.Параметры.Заполнить(СтрДокумент);
			ОбластьПодвал.Параметры.Заполнить(СтрДокумент);
			
			// Выведем Заголовок и шапку
			ТабДок.Вывести(ОбластьЗаголовок);
			ТабДок.Вывести(ОбластьШапка);
			
			ТаблицаРасчета = ТекДокумент.ПолучитьТаблицуРасчета();
			
			Для Каждого ТекСтрока Из ТаблицаРасчета Цикл
				
				ОбластьСтрока.Параметры.Заполнить(ТекСтрока);
				ОбластьСтрока.Параметры.Коэффициент = Формат(ТекСтрока.Коэффициент, "ЧС=-2; ЧН=-") + " %";
				// Выводим строки таблицы
				ТабДок.Вывести(ОбластьСтрока);
						
			КонецЦикла; 

			// Выводим итоги и подвал
			ОбластьИтоги.Параметры.СуммаРасходыОфисов = ТаблицаРасчета.Итог("СуммаРасходыОфисов");
			ТабДок.Вывести(ОбластьИтоги);
			//ТабДок.Вывести(ОбластьПодвал);
			
		КонецЦикла;
	
	КонецЕсли;

	ТабДок.АвтоМасштаб = Истина;
	
    Возврат ТабДок;
	
КонецФункции // СформироватьПечатнуюФормуПротоколРасчета()
 
// Rarus-spb byse 2012.12.27 {
Функция  СформироватьПечатнуюФормуПротоколРасчетаВХранилище (ИмяМакета, МассивСсылок) Экспорт 
	ПФ = СформироватьПечатнуюФормуПротоколРасчета(ИмяМакета,МассивСсылок);
	ХЗ = Новый ХранилищеЗначения(ПФ, Новый СжатиеДанных(9));
	Возврат ХЗ;
КонецФункции	

Процедура СохранениеПечатнойФормы (Объект) Экспорт
	МассивСсылок = Новый Массив;
	МассивСсылок.Добавить(Объект.Ссылка);
	ХранилищеПечатнойФормы = СформироватьПечатнуюФормуПротоколРасчетаВХранилище("", МассивСсылок);
	
	Движение                 = Объект.Движения.рс_ПротоколыРасчета.Добавить();
	Движение.Документ		 = Объект.Ссылка;
	Движение.ПротоколРасчета = ХранилищеПечатнойФормы;
КонецПроцедуры	
// Rarus-spb byse 2012.12.27 }

//1С-ИжТиСи, Кондратьев, 03.2020, обновление (
// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
    // Протокол расчета.
    КомандаПечати = КомандыПечати.Добавить();
    КомандаПечати.Идентификатор = "ПротоколРасчета";
    КомандаПечати.Представление = НСтр("ru = 'Протокол расчета'");
	КомандаПечати.Обработчик = "УправлениеПечатьюБПКлиент.ВыполнитьКомандуПечати";
	КомандаПечати.Порядок       = 10;
	
КонецПроцедуры
//1С-ИжТиСи, Кондратьев, 03.2020, обновление )

