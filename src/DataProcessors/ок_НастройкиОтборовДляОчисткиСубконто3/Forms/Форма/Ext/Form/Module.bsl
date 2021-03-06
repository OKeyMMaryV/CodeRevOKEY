
#Область СобытияФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтрокаКомпоновщика = Обработки.ок_НастройкиОтборовДляОчисткиСубконто3.ПолучитьЗначениеКонстанты("Ок_НастройкиОтбораДляОчисткиСубконто3", Неопределено);
	//СтрокаКомпоновщика = ОК_ОбщегоНазначения.ПолучитьЗначениеУниверсальнойНастройки("Казначейство", "ОтборыОчисткиСубконто3", Неопределено);
	
	СКД = РеквизитФормыВЗначение("Объект").ПолучитьМакет("Макет");
	АдресВременногоХранилища = ПоместитьВоВременноеХранилище(СКД, УникальныйИдентификатор);
	
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресВременногоХранилища);
	КомпоновщикНастроек.Инициализировать(ИсточникНастроек);
	КомпоновщикНастроек.ЗагрузитьНастройки(СКД.НастройкиПоУмолчанию);
	
	Если СтрокаКомпоновщика <> Неопределено Тогда
		Настройки = СериализаторXDTO.XMLЗначение(Тип("ХранилищеЗначения"), СтрокаКомпоновщика).Получить();
		КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область Команды

&НаКлиенте
Процедура СохранитьНастройки(Команда)
	СохранитьНастройкиНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Проверить(Команда)
	ПроверитьНаСервере();
КонецПроцедуры

#КонецОбласти


#Область Служебные

&НаСервере
Процедура СохранитьНастройкиНаСервере()
	
	НаборЗаписей = РегистрыСведений.СБ_НастройкиКазначейства.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Идентификатор.Установить("Ок_НастройкиОтбораДляОчисткиСубконто3");
	
	НовСтр = НаборЗаписей.Добавить();
	НовСтр.Идентификатор				= "Ок_НастройкиОтбораДляОчисткиСубконто3";
	НовСтр.ок_ПредставлениеРаздела 		= "Константы";
	НовСтр.ок_ПредставлениеНастройки 	= "Список значений отбора для очистки субконто 3";
	НовСтр.ЗначениеВХранилище           = Истина;
	Настройки 							= Новый ХранилищеЗначения(КомпоновщикНастроек.Настройки);
	НовСтр.ХранилищеЗначения 			= Новый ХранилищеЗначения(СериализаторXDTO.XMLСтрока(Настройки));
	НовСтр.ок_Комментарий 				= "#НТП_МП_02";
	
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьНаСервере()
	
	ТексЗапроса = Обработки.ок_НастройкиОтборовДляОчисткиСубконто3.ПолучитьТекстЗапросаДляПроверки();
	
	СКД = РеквизитФормыВЗначение("Объект").ПолучитьМакет("Макет");
	
	// Кэш
	СтарыйЗапрос = СКД.НаборыДанных.НаборДанных1.Запрос;
	
	СКД.НаборыДанных.НаборДанных1.Запрос = ТексЗапроса;
	НовыйИсточник = Новый ИсточникДоступныхНастроекКомпоновкиДанных(СКД);
	КомпоновщикНастроек.Инициализировать(НовыйИсточник);
	
	НастройкиКомпоновки = КомпоновщикНастроек.ПолучитьНастройки();
	
	// Установим параметры	
	НастройкиКомпоновки.ПараметрыДанных.УстановитьЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ПрофильРазноски"), 		ПрофильРазноски);
	НастройкиКомпоновки.ПараметрыДанных.УстановитьЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НаправлениеДоговора"), 	НаправлениеДоговора);
	НастройкиКомпоновки.ПараметрыДанных.УстановитьЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Контрагент"), 			Контрагент);
	НастройкиКомпоновки.ПараметрыДанных.УстановитьЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Договор"), 				Договор);

	КомпоновщикМакета 	= Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки 	= КомпоновщикМакета.Выполнить(СКД, НастройкиКомпоновки,,, Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ТаблицаЗначений = Новый ТаблицаЗначений;
	ПроцессорВывода.УстановитьОбъект(ТаблицаЗначений);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	Если ТаблицаЗначений.Количество() > 0 Тогда
		Сообщить("Субконто3 будет ОЧИЩЕНО!");
	Иначе
		Сообщить("Субконто3 НЕ будет ОЧИЩЕНО!");	
	КонецЕсли;
	
	СКД.НаборыДанных.НаборДанных1.Запрос = СтарыйЗапрос;
	// Инициализируем компановщик из кэша
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(СКД);
	КомпоновщикНастроек.Инициализировать(ИсточникНастроек);
	
КонецПроцедуры

#КонецОбласти



