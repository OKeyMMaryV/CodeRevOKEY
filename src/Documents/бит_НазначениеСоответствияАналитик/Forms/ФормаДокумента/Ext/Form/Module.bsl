
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Стандартные действия при создании на сервере.
	//бит_РаботаСДиалогамиСервер.ФормаОбъектаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);
	
	Если Отказ Тогда
	     Возврат;
	КонецЕсли;
	
	Если Параметры.Ключ.Пустая() Тогда
	     ПодготовитьформуНаСервере();
	КонецЕсли; 
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПодготовитьформуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
		
	Если ПараметрыЗаписи.РежимЗаписи = ПредопределенноеЗначение("РежимЗаписиДокумента.Проведение") Тогда
		КлючеваяОперация = "Проведениебит_НазначениеСоответствияАналитик";
		ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, КлючеваяОперация);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидСоответствияПриИзменении(Элемент)
	
	ИзменениеВидаСоответствия();
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЛеваяАналитика_1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	АналитикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ЛеваяАналитика_1АвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	АналитикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ЛеваяАналитика_1Очистка(Элемент, СтандартнаяОбработка)
	
	АналитикаОчистка(Элемент, СтандартнаяОбработка)
	
КонецПроцедуры

&НаКлиенте
Процедура ЛеваяАналитика_2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	АналитикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ЛеваяАналитика_2АвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	АналитикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ЛеваяАналитика_2Очистка(Элемент, СтандартнаяОбработка)
	
	АналитикаОчистка(Элемент, СтандартнаяОбработка)
	
КонецПроцедуры

&НаКлиенте
Процедура ЛеваяАналитика_3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	АналитикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ЛеваяАналитика_3АвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	АналитикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ЛеваяАналитика_3Очистка(Элемент, СтандартнаяОбработка)
	
	АналитикаОчистка(Элемент, СтандартнаяОбработка)
	
КонецПроцедуры

&НаКлиенте
Процедура ПраваяАналитика_1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	АналитикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПраваяАналитика_1АвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	АналитикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПраваяАналитика_1Очистка(Элемент, СтандартнаяОбработка)
	
	АналитикаОчистка(Элемент, СтандартнаяОбработка)
	
КонецПроцедуры

&НаКлиенте
Процедура ПраваяАналитика_2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	АналитикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПраваяАналитика_2АвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	АналитикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПраваяАналитика_2Очистка(Элемент, СтандартнаяОбработка)
	
	АналитикаОчистка(Элемент, СтандартнаяОбработка)
	
КонецПроцедуры

&НаКлиенте
Процедура ПраваяАналитика_3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	АналитикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПраваяАналитика_3АвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	АналитикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПраваяАналитика_3Очистка(Элемент, СтандартнаяОбработка)
	
	АналитикаОчистка(Элемент, СтандартнаяОбработка)
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура УстановитьПараметрыВыбора(Форма)

	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
	Если Объект.ВидСоответствия.Предопределенный 
		И Объект.ВидСоответствия.Код = "СтатьиОборотовБДР_СтатьиОборотовБДДС" Тогда
		
		// Для левой аналитики
		МассивПараметровЛев = Новый Массив;
		НовыйПараметр = Новый ПараметрВыбора("Отбор.ТипСтатьи", Перечисления.бит_ТипыСтатейОборотов.БДР);
		МассивПараметровЛев.Добавить(НовыйПараметр);
		ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметровЛев);            
		Элементы.ЛеваяАналитика_1.ПараметрыВыбора = ПараметрыВыбора;
		
		// Для правой аналитики
		МассивПараметровПрав = Новый Массив;
		НовыйПараметр = Новый ПараметрВыбора("Отбор.ТипСтатьи", Перечисления.бит_ТипыСтатейОборотов.БДДС);
		МассивПараметровПрав.Добавить(НовыйПараметр);
		ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметровПрав);            
		Элементы.ПраваяАналитика_1.ПараметрыВыбора = ПараметрыВыбора;
		
	Иначе
		
		// Для левой аналитики
		ПараметрыВыбора = Новый ФиксированныйМассив(Новый Массив);            
		Элементы.ЛеваяАналитика_1.ПараметрыВыбора = ПараметрыВыбора;
		
		// Для правой аналитики
		ПараметрыВыбора = Новый ФиксированныйМассив(Новый Массив);            
		Элементы.ПраваяАналитика_1.ПараметрыВыбора = ПараметрыВыбора;
		
	КонецЕсли; 
	
КонецПроцедуры // УстановитьПараметрыВыбора()

&НаСервереБезКонтекста 
Функция ПодготовитьПараметрыАналитики(Источник, Путь)
	
	Структура = Новый Структура();
	Если НЕ Источник = Неопределено Тогда
		Если Источник[Путь + "Показывать"] Тогда
			ПустойПараметрАналитики(Структура);
			Структура.Вставить("Код"	         , СокрЛП(Источник[Путь + "Код"]));
			Структура.Вставить("Наименование"	 , СокрЛП(Источник[Путь + "Наименование"]));
			Структура.Вставить("ТипЗначения"	 , Источник[Путь + "ТипЗначения"]);
			Структура.Вставить("Показывать"	     , Источник[Путь + "Показывать"]);
		Иначе
			ПустойПараметрАналитики(Структура);
		КонецЕсли; 
	Иначе
		ПустойПараметрАналитики(Структура);
	КонецЕсли; 
	
	Возврат Структура;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ПустойПараметрАналитики(Знач Структура)
	
	Структура.Вставить("Код"	         , "");
	Структура.Вставить("Наименование"	 , "");
	Структура.Вставить("ТипЗначения"	 , Новый ОписаниеТипов("Неопределено"));
	Структура.Вставить("Показывать"	     , Ложь);

КонецПроцедуры // ПодготовитьПараметрыАналитик()

&НаСервереБезКонтекста
Процедура ЗаполнитьПараметрыАналитик(ВидСоответствия, НастройкиИзмерений, ЛевоПраво)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВидСоответствия", ВидСоответствия);
	Запрос.УстановитьПараметр("ПустойПВХ", ПланыВидовХарактеристик.бит_ВидыДополнительныхАналитик.ПустаяСсылка());
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Реквизиты.ЛеваяАналитика_1.Наименование КАК ЛеваяАналитика_1Наименование,
	|	Реквизиты.ЛеваяАналитика_1.Код КАК ЛеваяАналитика_1Код,
	|	Реквизиты.ЛеваяАналитика_1.ТипЗначения КАК ЛеваяАналитика_1ТипЗначения,
	|	Реквизиты.ЛеваяАналитика_2.Наименование КАК ЛеваяАналитика_2Наименование,
	|	Реквизиты.ЛеваяАналитика_2.ТипЗначения КАК ЛеваяАналитика_2ТипЗначения,
	|	Реквизиты.ЛеваяАналитика_2.Код КАК ЛеваяАналитика_2Код,
	|	Реквизиты.ЛеваяАналитика_3.Наименование КАК ЛеваяАналитика_3Наименование,
	|	Реквизиты.ЛеваяАналитика_3.ТипЗначения КАК ЛеваяАналитика_3ТипЗначения,
	|	Реквизиты.ЛеваяАналитика_3.Код КАК ЛеваяАналитика_3Код,
	|	Реквизиты.ПраваяАналитика_1.Наименование КАК ПраваяАналитика_1Наименование,
	|	Реквизиты.ПраваяАналитика_1.ТипЗначения КАК ПраваяАналитика_1ТипЗначения,
	|	Реквизиты.ПраваяАналитика_1.Код КАК ПраваяАналитика_1Код,
	|	Реквизиты.ПраваяАналитика_2.Наименование КАК ПраваяАналитика_2Наименование,
	|	Реквизиты.ПраваяАналитика_2.ТипЗначения КАК ПраваяАналитика_2ТипЗначения,
	|	Реквизиты.ПраваяАналитика_2.Код КАК ПраваяАналитика_2Код,
	|	Реквизиты.ПраваяАналитика_3.Наименование КАК ПраваяАналитика_3Наименование,
	|	Реквизиты.ПраваяАналитика_3.ТипЗначения КАК ПраваяАналитика_3ТипЗначения,
	|	Реквизиты.ПраваяАналитика_3.Код КАК ПраваяАналитика_3Код,
	|	НЕ Реквизиты.ЛеваяАналитика_1 = &ПустойПВХ КАК ЛеваяАналитика_1Показывать,
	|	НЕ Реквизиты.ЛеваяАналитика_2 = &ПустойПВХ КАК ЛеваяАналитика_2Показывать,
	|	НЕ Реквизиты.ЛеваяАналитика_3 = &ПустойПВХ КАК ЛеваяАналитика_3Показывать,
	|	НЕ Реквизиты.ПраваяАналитика_1 = &ПустойПВХ КАК ПраваяАналитика_1Показывать,
	|	НЕ Реквизиты.ПраваяАналитика_2 = &ПустойПВХ КАК ПраваяАналитика_2Показывать,
	|	НЕ Реквизиты.ПраваяАналитика_3 = &ПустойПВХ КАК ПраваяАналитика_3Показывать
	|ИЗ
	|	Справочник.бит_ВидыСоответствийАналитик КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &ВидСоответствия";
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка          = РезультатЗапроса.Выбрать();
	
	Если НЕ Выборка.Следующий() Тогда
		Выборка = Неопределено;	
	КонецЕсли; 
	
	Для каждого Сторона Из ЛевоПраво Цикл
		НастройкиИзмерений.Вставить(Сторона.Ключ, ПодготовитьПараметрыАналитики(Выборка, Сторона.Ключ));
	КонецЦикла;

КонецПроцедуры // ЗаполнитьПараметрыАналитик()

&НаКлиентеНаСервереБезКонтекста
Функция ПривестиТипЗначения(ПараметрыАналитик, ИмяПоля, ИсходноеЗначение)

	Результат = ПараметрыАналитик[ИмяПоля].ТипЗначения.ПривестиЗначение(ИсходноеЗначение);

	Возврат Результат;
	
КонецФункции // ПривестиТипЗначения()

&НаСервереБезКонтекста
Процедура ПривестиТипыЗначений(Объект, ЛевоПраво, ПараметрыАналитик)
	
	Для каждого Сторона Из ЛевоПраво Цикл
		Объект[Сторона.Ключ] = ПривестиТипЗначения(ПараметрыАналитик, Сторона.Ключ, Объект[Сторона.Ключ]);
	КонецЦикла; 
	
КонецПроцедуры // ПривестиТипыАналитик()

&НаСервере
Процедура ПодготовитьФормуНаСервере()

	ЛевоПраво = Новый Структура();
	Для Й = 1 По 3 Цикл
		ЛевоПраво.Вставить("ЛеваяАналитика_" + Й);
		ЛевоПраво.Вставить("ПраваяАналитика_" + Й);
	КонецЦикла; 
	
	НастройкиИзмерений = Новый Структура(); 
	НастройкиИзмерений.Вставить("НастройкиАналитик", бит_МеханизмДопИзмерений.ПолучитьНастройкиДополнительныхАналитик());
	НастройкиИзмерений.Вставить("ПараметрыАналитик", Новый Структура);
	
	ИзменениеВидаСоответствия();
	
КонецПроцедуры // ПодготовитьформуНаСервере()

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;

	ПараметрыАналитик = Форма.НастройкиИзмерений.ПараметрыАналитик;
	Для каждого Сторона Из Форма.ЛевоПраво Цикл
		Элементы[Сторона.Ключ].Видимость = ПараметрыАналитик[Сторона.Ключ].Показывать;
		Элементы[Сторона.Ключ].Заголовок = ПараметрыАналитик[Сторона.Ключ].Наименование;
	КонецЦикла;
	
КонецПроцедуры // УправлениеФормой()

&НаСервере
Процедура ИзменениеВидаСоответствия()

	ЗаполнитьПараметрыАналитик(Объект.ВидСоответствия, НастройкиИзмерений.ПараметрыАналитик, ЛевоПраво);	
	ПривестиТипыЗначений(Объект, ЛевоПраво, НастройкиИзмерений.ПараметрыАналитик);
	УстановитьПараметрыВыбора(ЭтаФорма);
	
КонецПроцедуры // ИзменениеВидаСоответствия()

&НаКлиенте
Процедура АналитикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИмяЭлемента  = Элемент.Имя;
	ТекПараметры = НастройкиИзмерений.ПараметрыАналитик[ИмяЭлемента];
	ТекНастройка = НастройкиИзмерений.НастройкиАналитик[ТекПараметры.Код];
	Если ТекНастройка = Неопределено Тогда 			
		СтандартнаяОбработка = Ложь;   			
	Иначе 					
		СтрНастройки = Новый Структура(ИмяЭлемента, ТекНастройка); 				
		бит_МеханизмДопИзмеренийКлиент.ВыбратьТипСоставнойАналитики(ЭтаФорма
															  , Элемент
															  , Объект
															  , ИмяЭлемента
															  , СтандартнаяОбработка
															  , СтрНастройки); 			
	КонецЕсли;
														  
КонецПроцедуры

&НаКлиенте
Процедура АналитикаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Объект[Элемент.Имя]  = Неопределено;
	Объект[Элемент.Имя]  = ПривестиТипЗначения(НастройкиИзмерений.ПараметрыАналитик, Элемент.Имя, Объект[Элемент.Имя]);

КонецПроцедуры

#КонецОбласти