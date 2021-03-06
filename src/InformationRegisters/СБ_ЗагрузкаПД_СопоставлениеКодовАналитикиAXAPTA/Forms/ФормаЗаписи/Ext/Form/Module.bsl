////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПривестиТипыДанных();
	
КонецПроцедуры



////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ВидАналитикиПриИзменении(Элемент)
	
	ПривестиТипыДанных();
	
КонецПроцедуры



////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ <ИМЯ ТАБЛИЦЫ ФОРМЫ>

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ОПОВЕЩЕНИЙ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ПривестиТипыДанных()
	
	МассивТиповАналитики = Новый Массив;
	МассивТиповЗначенияАналитики = Новый Массив;
	ОписаниеТиповАналитики = Новый ОписаниеТипов(МассивТиповАналитики);
	ОписаниеТиповЗначенияАналитики = Новый ОписаниеТипов(МассивТиповЗначенияАналитики);
	
	Если Запись.ВидАналитики = ПредопределенноеЗначение("Перечисление.СБ_ЗагрузкаПД_ВидыАналитикКодовAXAPTA.Валюта") Тогда

		МассивТиповАналитики.Добавить(Тип("Строка"));
		КвалификаторСтроки = Новый КвалификаторыСтроки(20);
		ОписаниеТиповАналитики = Новый ОписаниеТипов(МассивТиповАналитики,, КвалификаторСтроки);
		
		МассивТиповЗначенияАналитики.Добавить(Тип("СправочникСсылка.Валюты"));
		ОписаниеТиповЗначенияАналитики = Новый ОписаниеТипов(МассивТиповЗначенияАналитики);
		
	ИначеЕсли Запись.ВидАналитики = ПредопределенноеЗначение("Перечисление.СБ_ЗагрузкаПД_ВидыАналитикКодовAXAPTA.СтавкаНДС") Тогда
		
		МассивТиповАналитики.Добавить(Тип("Число"));
		КвалификаторЧисла = Новый КвалификаторыЧисла(10);
		ОписаниеТиповАналитики = Новый ОписаниеТипов(МассивТиповАналитики,, КвалификаторЧисла);
		
		МассивТиповЗначенияАналитики.Добавить(Тип("ПеречислениеСсылка.СтавкиНДС"));
		ОписаниеТиповЗначенияАналитики = Новый ОписаниеТипов(МассивТиповЗначенияАналитики);
		
	ИначеЕсли Запись.ВидАналитики = ПредопределенноеЗначение("Перечисление.СБ_ЗагрузкаПД_ВидыАналитикКодовAXAPTA.ВидОперацииЗаявкаНаРасход") Тогда
		
		МассивТиповАналитики.Добавить(Тип("Строка"));
		КвалификаторСтроки = Новый КвалификаторыСтроки(20);
		ОписаниеТиповАналитики = Новый ОписаниеТипов(МассивТиповАналитики,, КвалификаторСтроки);
		
        МассивТиповЗначенияАналитики.Добавить(Тип("ПеречислениеСсылка.бит_ВидыОперацийЗаявкаНаРасходование"));
		ОписаниеТиповЗначенияАналитики = Новый ОписаниеТипов(МассивТиповЗначенияАналитики);
		
	ИначеЕсли Запись.ВидАналитики = ПредопределенноеЗначение("Перечисление.СБ_ЗагрузкаПД_ВидыАналитикКодовAXAPTA.СчетРСБУ") Тогда
		
		МассивТиповАналитики.Добавить(Тип("Строка"));
		КвалификаторСтроки = Новый КвалификаторыСтроки(20);
		ОписаниеТиповАналитики = Новый ОписаниеТипов(МассивТиповАналитики,, КвалификаторСтроки);
		
        МассивТиповЗначенияАналитики.Добавить(Тип("ПланСчетовСсылка.Хозрасчетный"));
		ОписаниеТиповЗначенияАналитики = Новый ОписаниеТипов(МассивТиповЗначенияАналитики);
		
	ИначеЕсли Запись.ВидАналитики = ПредопределенноеЗначение("Перечисление.СБ_ЗагрузкаПД_ВидыАналитикКодовAXAPTA.ВидПереводов") Тогда
		
		МассивТиповАналитики.Добавить(Тип("СправочникСсылка.СтатьиДвиженияДенежныхСредств"));
		КвалификаторСтроки = Новый КвалификаторыСтроки(20);
		ОписаниеТиповАналитики = Новый ОписаниеТипов(МассивТиповАналитики,, КвалификаторСтроки);
		
        МассивТиповЗначенияАналитики.Добавить(Тип("ПеречислениеСсылка.ОК_ВидыПереводов"));
		ОписаниеТиповЗначенияАналитики = Новый ОписаниеТипов(МассивТиповЗначенияАналитики);
		
	ИначеЕсли Запись.ВидАналитики = ПредопределенноеЗначение("Перечисление.СБ_ЗагрузкаПД_ВидыАналитикКодовAXAPTA.ВидОперацииПоступлениеДС") Тогда
		
		МассивТиповАналитики.Добавить(Тип("Строка"));
		КвалификаторСтроки = Новый КвалификаторыСтроки(20);
		ОписаниеТиповАналитики = Новый ОписаниеТипов(МассивТиповАналитики,, КвалификаторСтроки);
		
        МассивТиповЗначенияАналитики.Добавить(Тип("ПеречислениеСсылка.ВидыОперацийПоступлениеДенежныхСредств"));
		ОписаниеТиповЗначенияАналитики = Новый ОписаниеТипов(МассивТиповЗначенияАналитики);
		
	ИначеЕсли Запись.ВидАналитики = ПредопределенноеЗначение("Перечисление.СБ_ЗагрузкаПД_ВидыАналитикКодовAXAPTA.ТипКонтрагента") Тогда
		
		МассивТиповАналитики.Добавить(Тип("Строка"));
		КвалификаторСтроки = Новый КвалификаторыСтроки(20);
		ОписаниеТиповАналитики = Новый ОписаниеТипов(МассивТиповАналитики,, КвалификаторСтроки);
		
        МассивТиповЗначенияАналитики.Добавить(Тип("ПеречислениеСсылка.СБ_ТипСчетаAXAPTA"));
		ОписаниеТиповЗначенияАналитики = Новый ОписаниеТипов(МассивТиповЗначенияАналитики);
		
	ИначеЕсли Запись.ВидАналитики = ПредопределенноеЗначение("Перечисление.СБ_ЗагрузкаПД_ВидыАналитикКодовAXAPTA.ПрофильРазноски_1С") Тогда
		
		МассивТиповАналитики.Добавить(Тип("Строка"));
		КвалификаторСтроки = Новый КвалификаторыСтроки(20);
		ОписаниеТиповАналитики = Новый ОписаниеТипов(МассивТиповАналитики,, КвалификаторСтроки);
		
        МассивТиповЗначенияАналитики.Добавить(Тип("Булево"));
		ОписаниеТиповЗначенияАналитики = Новый ОписаниеТипов(МассивТиповЗначенияАналитики);
		
	ИначеЕсли Запись.ВидАналитики = ПредопределенноеЗначение("Перечисление.СБ_ЗагрузкаПД_ВидыАналитикКодовAXAPTA.ПрофильРазноски_AXAPTA") Тогда
		
		МассивТиповАналитики.Добавить(Тип("Строка"));
		КвалификаторСтроки = Новый КвалификаторыСтроки(20);
		ОписаниеТиповАналитики = Новый ОписаниеТипов(МассивТиповАналитики,, КвалификаторСтроки);
		
        МассивТиповЗначенияАналитики.Добавить(Тип("Булево"));
		ОписаниеТиповЗначенияАналитики = Новый ОписаниеТипов(МассивТиповЗначенияАналитики);
		
	КонецЕсли; 
	
	Элементы.Аналитика.ОграничениеТипа = ОписаниеТиповАналитики; 
	Элементы.ЗначениеАналитики.ОграничениеТипа = ОписаниеТиповЗначенияАналитики; 
	
	Запись.Аналитика = ОписаниеТиповАналитики.ПривестиЗначение(Запись.Аналитика);
	Запись.ЗначениеАналитики = ОписаниеТиповЗначенияАналитики.ПривестиЗначение(Запись.ЗначениеАналитики);
	
КонецПроцедуры
