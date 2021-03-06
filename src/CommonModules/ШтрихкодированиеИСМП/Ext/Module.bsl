#Область ПрограммныйИнтерфейс

// Определяет по значению штрихкода принадлежность к обувной продукции: потребительской упаковке или логистической упаковке.
// 
// Параметры:
// 	Штрихкод - Строка - Штрихкод маркируемой продукции.
// 	УчитыватьЛогистическуюУпаковку - Булево - Логистическая упаковка будет так же будет подвергнута анализу.
// Возвращаемое значение:
// 	Булево - Истина - в случае принадлежности штрихкода к обувной продукции, Ложь - в обратном случае.
Функция ЭтоШтрихкодОбувнойПродукции(КодМаркировки, УчитыватьЛогистическуюУпаковку = Ложь) Экспорт
	
	ЭтоКодПотребительскойУпаковки = ШтрихкодированиеИСМПКлиентСервер.ЭтоКодМаркировкиПотребительскойУпаковки(КодМаркировки);
	
	Если УчитыватьЛогистическуюУпаковку Тогда
		
		Возврат ЭтоКодПотребительскойУпаковки
			Или ШтрихкодированиеИСМПКлиентСервер.ЭтоКодЛогистическойУпаковки(КодМаркировки);
			
	КонецЕсли;
	
	Возврат ЭтоКодПотребительскойУпаковки;
	
КонецФункции

#КонецОбласти