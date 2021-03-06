#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ - ОБРАБОТЧИКИ СОБЫТИЙ ОБЪЕКТА.

#Область ОбработчикиСобытий


// Процедура - обработчик события "ПриКомпоновкеРезультата" формы.
// 
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)

	// Изменим текст запроса
	
	НаборДанных = СхемаКомпоновкиДанных.НаборыДанных.Найти("Обороты");
	
	Если НаборДанных = Неопределено Тогда
		ТекстСообщения = НСтр("ru='Не обнаружен набор данных для получения оборотов!'");
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
		
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса = НаборДанных.Запрос;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "бит_Дополнительный_2", РегистрБухгалтерии.ИмяОбъекта);
	
	// Добавим сумму МУ
	МетаРесурсСуммаМУ = Метаданные.РегистрыБухгалтерии[РегистрБухгалтерии.ИмяОбъекта].Ресурсы.Найти("СуммаМУ");
	
	Если МетаРесурсСуммаМУ = Неопределено Тогда
		ТекстРесурсыМУ = "
		|0,
		|0,
		|0,
		|0";
	Иначе
		ТекстРесурсыМУ = Неопределено;
	КонецЕсли;
	
	Если НЕ ТекстРесурсыМУ = Неопределено Тогда
		ТекстДляЗамены = ПолучитьТекстПоМаркерам(ТекстЗапроса, "// Начало.РегистрБухгалтерии.РесурсыМУ", "// Конец.РегистрБухгалтерии.РесурсыМУ");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ТекстДляЗамены, ТекстРесурсыМУ);
	КонецЕсли;
	
	НаборДанных.Запрос = ТекстЗапроса;
	
	// Установим параметры
	
	СписокПараметровНаФорме = Новый СписокЗначений;
	ИмяОтчета = ЭтотОбъект.Метаданные().Имя; 
	Отчеты[ИмяОтчета].ЗаполнитьДополнительныеСписки(СписокПараметровНаФорме);
	
	Для каждого ЭлементСписка Из СписокПараметровНаФорме Цикл
		
		ИмяПараметра = ЭлементСписка.Значение;
		
		бит_ОтчетыСервер.УстановитьЗначениеПараметраКомпоновщика(КомпоновщикНастроек, 
																 ЭтотОбъект[ИмяПараметра], 
																 ИмяПараметра);
		
	КонецЦикла;  	 
	
	// Определим название для группировки в которой отображаются обороты по регистру бухгалтерии.
	ТипПроводки_ДанныеРегистра = НСтр("ru='Обороты за период'");
	
	ПараметрыСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных;
	
	ПараметрыСКД.УстановитьЗначениеПараметра("ТипПроводки_ДанныеРегистра", ТипПроводки_ДанныеРегистра);
	ПараметрыСКД.УстановитьЗначениеПараметра("ПоВсемОрганизациям", НЕ ЗначениеЗаполнено(Организация));
	
КонецПроцедуры // ПриКомпоновкеРезультата()


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьТекстПоМаркерам(Текст, МаркерНачало, МаркерКонец)
	
	ПозицияМаркерНачало = Найти(Текст, МаркерНачало) + СтрДлина(МаркерНачало);
	ПозицияМаркерКонец  = Найти(Текст, МаркерКонец);
	
	Возврат СокрЛП(Сред(Текст, ПозицияМаркерНачало, ПозицияМаркерКонец - ПозицияМаркерНачало - 1));
	
КонецФункции

#КонецОбласти

#КонецЕсли
