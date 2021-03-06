////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьСписокПрофилейРазноскиНаСервере();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Список профилей разноски

&НаКлиенте
Процедура СписокПрофилиРазноскиПередУдалением(Элемент, Отказ)
	
	ТекущиеДанные = Элементы.СписокПрофилиРазноски.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;	
	КонецЕсли; 
	
	УдалитьЗаписиПоКодуПрофиляРазноски(ТекущиеДанные.Код);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПрофилиРазноскиКодПриИзменении(Элемент)

	ТекущаяСтрока = Элементы.СписокПрофилиРазноски.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;	
	КонецЕсли; 
	
	ОтработатьИзменениеКодаПрофиляРазноскиНаСервере(ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПрофилиРазноскиНаименованиеПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СписокПрофилиРазноски.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;	
	КонецЕсли; 
	
	ОтработатьИзменениеНаименования(ТекущиеДанные.Код, ТекущиеДанные.Наименование, ТекущиеДанные.ВидОперацииЗаявкаНаРасход);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПрофилиРазноскиСчетРСБУПриИзменении(Элемент)
	ОтработатьИзменениеЗначенияАналитикиНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура СписокПрофилиРазноскиВидОперацииЗаявкаНаРасходПриИзменении(Элемент)
	ОтработатьИзменениеЗначенияАналитикиНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура СписокПрофилиРазноскиВидОперацииПоступлениеДСПриИзменении(Элемент)
	ОтработатьИзменениеЗначенияАналитикиНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура СписокПрофилиРазноскиПрофильРазноски_AXAPTAПриИзменении(Элемент)
	ОтработатьИзменениеЗначенияАналитикиНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура СписокПрофилиРазноскиПрофильРазноски_1СПриИзменении(Элемент)
	ОтработатьИзменениеЗначенияАналитикиНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура СписокПрофилиРазноскиТипКонтрагентаПриИзменении(Элемент)
	ОтработатьИзменениеЗначенияАналитикиНаКлиенте();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ОПОВЕЩЕНИЙ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ЗаполнитьСписокПрофилейРазноскиНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Сопоставление.Аналитика КАК Код,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА Сопоставление.ВидАналитики = ЗНАЧЕНИЕ(Перечисление.СБ_ЗагрузкаПД_ВидыАналитикКодовAXAPTA.ВидОперацииЗаявкаНаРасход)
	|				ТОГДА Сопоставление.НаименованиеАналитики
	|		КОНЕЦ) КАК Наименование,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА Сопоставление.ВидАналитики = ЗНАЧЕНИЕ(Перечисление.СБ_ЗагрузкаПД_ВидыАналитикКодовAXAPTA.ВидОперацииЗаявкаНаРасход)
	|				ТОГДА Сопоставление.ЗначениеАналитики
	|		КОНЕЦ) КАК ВидОперацииЗаявкаНаРасход,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА Сопоставление.ВидАналитики = ЗНАЧЕНИЕ(Перечисление.СБ_ЗагрузкаПД_ВидыАналитикКодовAXAPTA.СчетРСБУ)
	|				ТОГДА Сопоставление.ЗначениеАналитики
	|		КОНЕЦ) КАК СчетРСБУ,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА Сопоставление.ВидАналитики = ЗНАЧЕНИЕ(Перечисление.СБ_ЗагрузкаПД_ВидыАналитикКодовAXAPTA.ВидОперацииПоступлениеДС)
	|				ТОГДА Сопоставление.ЗначениеАналитики
	|		КОНЕЦ) КАК ВидОперацииПоступлениеДС,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА Сопоставление.ВидАналитики = ЗНАЧЕНИЕ(Перечисление.СБ_ЗагрузкаПД_ВидыАналитикКодовAXAPTA.ПрофильРазноски_AXAPTA)
	|				ТОГДА Сопоставление.ЗначениеАналитики
	|		КОНЕЦ) КАК ПрофильРазноски_AXAPTA,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА Сопоставление.ВидАналитики = ЗНАЧЕНИЕ(Перечисление.СБ_ЗагрузкаПД_ВидыАналитикКодовAXAPTA.ПрофильРазноски_1С)
	|				ТОГДА Сопоставление.ЗначениеАналитики
	|		КОНЕЦ) КАК ПрофильРазноски_1С,
	|	МАКСИМУМ(ВЫБОР
	|			КОГДА Сопоставление.ВидАналитики = ЗНАЧЕНИЕ(Перечисление.СБ_ЗагрузкаПД_ВидыАналитикКодовAXAPTA.ТипКонтрагента)
	|				ТОГДА Сопоставление.ЗначениеАналитики
	|		КОНЕЦ) КАК ТипКонтрагента,
	|	Сопоставление.Аналитика КАК ПрежнийКод,
	|	ИСТИНА КАК ЗаписьСуществует
	|ИЗ
	|	РегистрСведений.СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA КАК Сопоставление
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA КАК СписокПрофилей
	|		ПО Сопоставление.Аналитика = СписокПрофилей.Аналитика
	|			И (СписокПрофилей.ВидАналитики = ЗНАЧЕНИЕ(Перечисление.СБ_ЗагрузкаПД_ВидыАналитикКодовAXAPTA.ВидОперацииЗаявкаНаРасход))
	|ГДЕ
	|	Сопоставление.ВидАналитики В(&АналитикиПоПрофилюРазноски)
	|
	|СГРУППИРОВАТЬ ПО
	|	Сопоставление.Аналитика,
	|	Сопоставление.Аналитика
	|
	|УПОРЯДОЧИТЬ ПО
	|	Код";
	Запрос.УстановитьПараметр("АналитикиПоПрофилюРазноски",	ВидыАналитикПоПрофилюРазноски());	 //Загрузка ПД: виды аналитик кодов (AXAPTA)
	СписокПрофилиРазноски.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Функция ВидыАналитикПоПрофилюРазноски()
 
	ВидыАналитик = Перечисления.СБ_ЗагрузкаПД_ВидыАналитикКодовAXAPTA;

	АналитикиПоПрофилюРазноски = Новый Массив;
	АналитикиПоПрофилюРазноски.Добавить(ВидыАналитик.ВидОперацииЗаявкаНаРасход);
	АналитикиПоПрофилюРазноски.Добавить(ВидыАналитик.ВидОперацииПоступлениеДС);
	АналитикиПоПрофилюРазноски.Добавить(ВидыАналитик.ПрофильРазноски_1С);
	АналитикиПоПрофилюРазноски.Добавить(ВидыАналитик.ПрофильРазноски_AXAPTA);
	АналитикиПоПрофилюРазноски.Добавить(ВидыАналитик.СчетРСБУ);
	АналитикиПоПрофилюРазноски.Добавить(ВидыАналитик.ТипКонтрагента);

	Возврат АналитикиПоПрофилюРазноски;
	
КонецФункции // ()

&НаСервере
Процедура ОтработатьИзменениеКодаПрофиляРазноскиНаСервере(ТекущаяСтрока)
	
	ТекущиеДанные = СписокПрофилиРазноски.НайтиПоИдентификатору(ТекущаяСтрока);
	
	Если ТекущиеДанные.ПрежнийКод = ТекущиеДанные.Код Тогда
		Возврат;
	КонецЕсли; 
	
	ОсновнойВидАналитики = "ВидОперацииЗаявкаНаРасход";
	
	Если ТекущиеДанные.ЗаписьСуществует Тогда
	
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA.ВидАналитики,
		|	СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA.Аналитика,
		|	СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA.ЗначениеАналитики,
		|	СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA.НаименованиеАналитики
		|ИЗ
		|	РегистрСведений.СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA КАК СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA
		|ГДЕ
		|	СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA.Аналитика = &Аналитика
		|	И СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA.ВидАналитики В(&АналитикиПоПрофилюРазноски)";
		Запрос.УстановитьПараметр("АналитикиПоПрофилюРазноски", ВидыАналитикПоПрофилюРазноски());
		Запрос.УстановитьПараметр("Аналитика",					ТекущиеДанные.ПрежнийКод);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			МенеджерЗаписи = РегистрыСведений.СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);
			МенеджерЗаписи.Прочитать();
			
			ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);
			МенеджерЗаписи.Аналитика = ТекущиеДанные.Код;
			МенеджерЗаписи.Записать();
			
		КонецЦикла; 
		
	Иначе
		
		МенеджерЗаписи = РегистрыСведений.СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.ВидАналитики 			= Перечисления.СБ_ЗагрузкаПД_ВидыАналитикКодовAXAPTA[ОсновнойВидАналитики];
		МенеджерЗаписи.Аналитика				= ТекущиеДанные.Код;
		МенеджерЗаписи.НаименованиеАналитики	= ТекущиеДанные.Наименование;
		МенеджерЗаписи.ЗначениеАналитики		= ТекущиеДанные[ОсновнойВидАналитики];
		
		МенеджерЗаписи.Записать(Ложь);
				
	КонецЕсли; 
	
	ТекущиеДанные.ПрежнийКод 		= ТекущиеДанные.Код;
	ТекущиеДанные.ЗаписьСуществует 	= Истина;
	
	СписокПрофилиРазноски.Сортировать("Код");

КонецПроцедуры

&НаСервере
Процедура УдалитьЗаписиПоКодуПрофиляРазноски(КодПрофиля)

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA.ВидАналитики,
	|	СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA.Аналитика,
	|	СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA.ЗначениеАналитики,
	|	СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA.НаименованиеАналитики
	|ИЗ
	|	РегистрСведений.СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA КАК СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA
	|ГДЕ
	|	СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA.Аналитика = &Аналитика
	|	И СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA.ВидАналитики В(&АналитикиПоПрофилюРазноски)";
	Запрос.УстановитьПараметр("АналитикиПоПрофилюРазноски", ВидыАналитикПоПрофилюРазноски());
	Запрос.УстановитьПараметр("Аналитика",					КодПрофиля);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		МенеджерЗаписи = РегистрыСведений.СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);
		МенеджерЗаписи.Удалить();
		
	КонецЦикла; 

КонецПроцедуры

&НаКлиенте
Процедура ОтработатьИзменениеЗначенияАналитикиНаКлиенте()

	ТекущиеДанные = Элементы.СписокПрофилиРазноски.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;	
	КонецЕсли; 
	
	ВидАналитикиСтрока = СтрЗаменить(Элементы.СписокПрофилиРазноски.ТекущийЭлемент.Имя, "СписокПрофилиРазноски", "");

	ОтработатьИзменениеЗначенияАналитикиНаСервере(ТекущиеДанные.Код, ВидАналитикиСтрока, ТекущиеДанные[ВидАналитикиСтрока]);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтработатьИзменениеЗначенияАналитикиНаСервере(Код, ВидАналитикиСтрока, ЗначениеАналитики)

	МенеджерЗаписи = РегистрыСведений.СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ВидАналитики 		= Перечисления.СБ_ЗагрузкаПД_ВидыАналитикКодовAXAPTA[ВидАналитикиСтрока];
	МенеджерЗаписи.Аналитика			= Код;
	МенеджерЗаписи.ЗначениеАналитики	= ЗначениеАналитики;
	МенеджерЗаписи.Записать();

КонецПроцедуры

&НаСервереБезКонтекста 
Процедура ОтработатьИзменениеНаименования(Код, Наименование, ЗначениеАналитики)

	МенеджерЗаписи = РегистрыСведений.СБ_ЗагрузкаПД_СопоставлениеКодовАналитикиAXAPTA.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ВидАналитики 			= Перечисления.СБ_ЗагрузкаПД_ВидыАналитикКодовAXAPTA.ВидОперацииЗаявкаНаРасход;
	МенеджерЗаписи.Аналитика				= Код;
	МенеджерЗаписи.НаименованиеАналитики	= Наименование;
	МенеджерЗаписи.ЗначениеАналитики		= ЗначениеАналитики;
	МенеджерЗаписи.Записать();

КонецПроцедуры
 