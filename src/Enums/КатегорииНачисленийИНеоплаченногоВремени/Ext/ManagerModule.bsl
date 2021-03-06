#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Формирует массив категорий начислений пособия оплачиваемые за счет ФСС.
//
// Возвращаемое значение:
//    Массив - Значения типа ПеречислениеСсылка.КатегорииНачисленийИНеоплаченногоВремени.
//
Функция КатегорииПособийЗаСчетФСС() Экспорт
	Массив = Новый Массив;
	
	Массив.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаБольничногоЛиста);
	Массив.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаБольничногоНесчастныйСлучайНаПроизводстве);
	Массив.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОплатаБольничногоПрофзаболевание);
	Массив.Добавить(Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ОтпускПоБеременностиИРодам);
	
	Возврат Массив;
КонецФункции

#КонецОбласти

#КонецЕсли